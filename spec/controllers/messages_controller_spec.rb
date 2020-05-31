require 'rails_helper'

describe MessagesController do

  # 複数のexampleで同一のインスタンスを使いたい場合、
  # letを利用してテスト中使用するインスタンスを定義
  let(:group) { create(:group)}
  let(:user) { create(:user)}


  describe '#index' do
    context 'ユーザーがログインしている場合' do
      before do
        login user
        get :index, params: { group_id: group.id }
      end

      it '@messageに正しい値が入っていること' do
        expect(assigns(:message)).to be_a_new(Message)
      end

      it '@groupに正しい値が入っていること' do
        expect(assigns(:group)).to eq group
      end

      it 'index.html.namlに遷移すること' do
        expect(response).to render_template :index
      end
    end

    context 'ユーザーがログインしていない場合' do
      before do
        get :index, params: { group_id: group.id }
      end

      it 'ログイン画面にリダイレクトできていること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end


    describe '#create' do
      let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }

      context 'ユーザーがログインしている場合' do
        before do
          login user
        end

        context 'メッセージの保存に成功した場合' do
          subject {
            post :create,
            params: params
          }
          it 'messageを保存すること' do
            expect{ subject }.to change(Message, :count).by(1)
          end

          it 'messageが保存された後、リダイレクト先のgroup_messages_pathへ遷移すること' do
            subject
            expect(response).to redirect_to(group_messages_path(group))
          end
        end

        context 'メッセージの保存に失敗した場合' do
          let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, content: nil, image: nil) } }

          subject {
            post :create,
            params: invalid_params
          }

          it 'messageが保存されないこと' do
            expect{ subject }.not_to change(Message, :count)
          end

          it 'messageが保存されなかった後、index.html.hamlへ遷移すること' do
            subject
            expect(response).to render_template :index
          end

        end
      end

      context 'ユーザーがログインしていない場合' do
        it 'ログイン画面new.html.hamlに遷移すること' do
        post :create, params: params
        expect(response).to redirect_to(new_user_session_path)
        end
      end

    end

end

# メッセージの保存に成功した場合などにおいて、
# expectの引数として、subjectを定義して渡しています。
# expectの引数が長くなってしまう際は、このようにして記述を切り出すことができます。

# メッセージの保存に成功した場合のエクスペクテーションは、
# 「postメソッドでcreateアクションを擬似的にリクエストをした結果」という意味になります。