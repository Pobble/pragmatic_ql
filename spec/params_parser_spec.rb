require 'spec_helper'
RSpec.describe PragmaticQL::ParamsParser do
  subject do
    described_class.new(include_string: include_string)
  end

  let(:current_account) { nil }

  describe '#inclusive_of' do
    let(:include_model) { subject.include_model }

    context 'when nil include string' do
      let(:include_string) { nil }

      it do
        expect(include_model).to be_empty
        expect(include_model).not_to be_inclusive_of(:account)
      end
    end

    context 'when empty string' do
      let(:include_string) { ' ' }

      it do
        expect(include_model).to be_empty
        expect(include_model).not_to be_inclusive_of(:account)
      end
    end

    context 'when include_string includes whitespaces' do
      let(:include_string) do
        "\naccount.names,\r\n account.email_identity  .email"
      end

      it do
        expect(include_model).not_to be_empty
        expect(include_model).to be_inclusive_of(:account)

        account_im = include_model.for(:account)
        expect(account_im).to be_inclusive_of(:names)

        account_im = include_model.for(:account)
        expect(account_im).to be_inclusive_of(:email_identity)

        account_email_identity_im = account_im.for(:email_identity)
        expect(account_email_identity_im).to be_inclusive_of(:email)
      end

      describe '#to_s' do
        it do
          expect(include_model.to_s).to eq('account.names,account.email_identity.email')
        end
      end
    end

    context 'when comprehensive include_string' do
      let(:include_string) do
        'other_meta,account.names,account.email_identity.email,' +
          'account.email_identity.title,lesson.works'
      end

      it 'should include everythnig related' do
        expect(include_model).not_to be_empty
        expect(include_model).to be_inclusive_of(:other_meta)
        expect(include_model).to be_inclusive_of(:account)
        expect(include_model).to be_inclusive_of(:lesson)
        expect(include_model).not_to be_inclusive_of(:names)

        account_im = include_model.for(:account)
        expect(account_im).not_to be_empty
        expect(account_im).to be_inclusive_of(:email_identity)
        expect(account_im).to be_inclusive_of(:names)
        expect(account_im).not_to be_inclusive_of(:email)
        expect(account_im).not_to be_inclusive_of(:account)

        account_names_im = account_im.for(:names)
        expect(account_names_im).to be_empty

        account_email_identity_im = account_im.for(:email_identity)
        expect(account_email_identity_im).to be_inclusive_of(:email)
        expect(account_email_identity_im).to be_inclusive_of(:title)
        expect(account_email_identity_im).not_to be_inclusive_of(:something_i_made_up)

        account_email_identity_email_im = account_email_identity_im.for(:email)
        expect(account_email_identity_email_im).to be_empty

        lesson_im = include_model.for(:lesson)
        expect(lesson_im).to be_inclusive_of(:works)

        lesson_works_im = include_model.for(:lesson)
        expect(lesson_works_im).to be_inclusive_of(:works)
      end

      it 'should convert string keys to symbols' do
        expect(include_model).to be_inclusive_of('account')
        account_im = include_model.for('account')
        expect(account_im).to be_inclusive_of('names')
      end

      describe '#to_s' do
        it do
          expect(include_model.to_s).to eq(include_string)
          expect(include_model.for(:account).to_s).to eq("names,email_identity.email,email_identity.title")
          expect(include_model.for(:account).for(:email_identity).to_s).to eq("email,title")
          expect(include_model.for(:account).for(:email_identity).for(:email).to_s).to eq("")

          expect(include_model.for(:other_meta).to_s).to eq("")
          expect(include_model.for(:not_existing).to_s).to eq("")
        end
      end

      describe '#to_h' do
        it do
          expect(include_model.to_h).to match({
            :account => {:email_identity=>{:email=>{}, :title=>{}}, :names=>{}},
            :lesson => {:works=>{}},
            :other_meta => {},
          })
          expect(include_model.for(:account).to_h).to match({
            :email_identity => {:email=>{}, :title=>{}},
            :names => {},
          })
          expect(include_model.for(:account).for(:email_identity).to_h).to match({
            :email => {},
            :title => {},
          })
          expect(include_model.for(:account).for(:email_identity).for(:email).to_h).to eq({})

          expect(include_model.for(:other_meta).to_h).to eq({})
          expect(include_model.for(:not_existing).to_h).to eq({})
        end
      end
    end

    describe 'pagination' do
      let(:lesson_im) { include_model.for(:lesson) }
      let(:works_im)  { lesson_im.for(:works) }

      context 'when include_string with pagination' do
        let(:include_string) do
          'lesson.works.page.2,lesson.works.limit.10,lesson.works.order.desc'
        end

        it { expect(include_model).to be_inclusive_of(:lesson) }
        it { expect(lesson_im).to be_inclusive_of(:works) }
        it { expect(works_im.pagination.page).to eq 2 }
        it { expect(works_im.pagination.limit).to eq 10 }
        it { expect(works_im.pagination.order).to eq :desc }

        describe '#to_s' do
          it do
            expect(include_model.to_s).to eq(include_string)
            expect(include_model.for(:lesson).to_s).to eq('works.page.2,works.limit.10,works.order.desc')
            expect(include_model.for(:lesson).for(:works).to_s).to eq('page.2,limit.10,order.desc')
            expect(include_model.for(:lesson).for(:works).for(:page).to_s).to eq('2')
          end
        end
      end

      context 'when include_string with default pagination' do
        let(:include_string) do
          'lesson.works'
        end

        it { expect(include_model).to be_inclusive_of(:lesson) }
        it { expect(lesson_im).to be_inclusive_of(:works) }
        it { expect(works_im.pagination.page).to eq 1 }
        it { expect(works_im.pagination.limit).to eq 50 }
        it { expect(works_im.pagination.order).to eq :asc }

        describe '#to_s' do
          it do
            expect(include_model.to_s).to eq(include_string)
          end
        end
      end

      context 'when include_string with not recognized pagination values' do
        let(:include_string) do
          'lesson.works.page.wrong,lesson.works.limit.wrong,lesson.works.order.wrong'
        end

        it { expect(include_model).to be_inclusive_of(:lesson) }
        it { expect(lesson_im).to be_inclusive_of(:works) }
        it { expect(works_im.pagination.page).to eq 1 }
        it { expect(works_im.pagination.limit).to eq 50 }
        it { expect(works_im.pagination.order).to eq :asc }

        context 'when negative limit' do
          let(:include_string) { 'lesson.works.limit.-10' }
          it { expect(works_im.pagination.limit).to eq 50 }
        end

        context 'when negative page' do
          let(:include_string) { 'lesson.works.page.-10' }
          it { expect(works_im.pagination.page).to eq 1 }
        end

        context 'when limit over maximum' do
          let(:include_string) { 'lesson.works.limit.99999999999999999' }
          it { expect(works_im.pagination.limit).to eq 50 }
        end

        context 'when zero limit' do
          let(:include_string) { 'lesson.works.limit.0' }
          it { expect(works_im.pagination.limit).to eq 50 }
        end
      end
    end
  end
end
