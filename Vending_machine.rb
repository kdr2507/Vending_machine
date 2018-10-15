class Vending_machine
    #투입한 돈
    #投入したお金
    $inputPrice = 0
    
    #매출
    #売り出し
    $sale = 0

    #초기 기본 상품
    #最初の商品
    $product = Array.new{Array.new}

    $product = [
        ["コーラ", 120, 5],
        
    ]

    
    def menu()
        #메뉴
        #メニュー
        puts "\n-----------------------------------------------------------"
        puts "投入した金額 : #{$inputPrice}円"
        puts "10円玉、50円玉、100円玉、1000円さつを入れてください。"
        product_list()
        puts "\n購入をしたいなら[-2]を、払い戻しなら[-1]を、管理を望むなら[0]を入力してください。"
        order = gets.chomp

        case order
            when "0" then return management()  #관리　管理
            when "10" then return inputCoin(order.to_i)    #돈 투입　お金投入
            when "50" then return inputCoin(order.to_i)    #돈 투입　お金投入
            when "100" then return inputCoin(order.to_i)   #돈 투입　お金投入
            when "1000" then return inputCoin(order.to_i)  #돈 투입　お金投入
            when "-1" then return refund()     #환불    払い戻し
            when "-2" then return purchase()     #구입　購入
            else return menu()             #설정된 돈 이외에는 반응 안함　設定しているお金以外は反応なし
        end
    end


    def inputCoin(inputMoney)
        #동전 투입
        #お金投入
        $inputPrice += inputMoney
        
        return menu()
    end


    def refund()
        #동전 환불
        #払い戻し
        puts "\n-----------------------------------------------------------"
        printf("%d円払い戻しました。\n\n", $inputPrice)
        
        $inputPrice = 0
        
        return menu()
    end

    def purchase()
        #구입
        #購入
        puts "\n-----------------------------------------------------------"
        puts "購入したい商品の番号を入力してください。（いちばん左にある数字です。）メニューに帰りたいなら[0]を、払い戻ししたいなら[-1]]を入力してください。"
        order = gets.chomp
        
        #남은금액 환불을 원할경우
        #残ったお金の払い戻しを望む場合
        if order.to_i == 0
            return menu()
        elsif order.to_i == -1
            return refund()
        end
        
        #리스트에 존재하는가 체크
        #商品リストに入力した商品が存在するどうかを確認
        while order.to_i <= 0 || order.to_i > $product.length
            puts "正しい番号を入力してください。"
            return purchase()
        end
        
        #투입한 돈이 부족한지 체크
        #購入したお金が十分かを確認
        while $product[order.to_i-1][1] > $inputPrice
            puts "お金が足りないです。"
            return purchase()
        end
        
        #상품의 재고가 남아있는지 체크
        #商品があるのかを確認
        while $product[order.to_i-1][2] <= 0
            puts "商品が残っていません。"
            return purchase()
        end
        
        #상품 구입
        #商品購入
        $product[order.to_i-1][2] = $product[order.to_i-1][2]-1
        
        #투입한 총 금액 감소
        #購入したお金で商品の価格を引き算
        $inputPrice = $inputPrice-$product[order.to_i-1][1]
        
        #매출 증가
        #売り出し
        $sale = $sale + $product[order.to_i-1][1]
        product_list()
        return purchase()
        
    end

    def management()
        #자판기 관리(음료수 이름, 가격, 개수 설정)
        #自動販売機管理
        product_list_management()
        puts "\n-----------------------------------------------------------"
        puts "メニューは[0]を、商品追加は[１]を、今までの売り出しを確認したいなら[2]を入力してください。"
        
        order = gets.chomp
        
        case order
            when "0" then return menu()    #메뉴화면    メニュー
            when "1" then return product_add()  #상품 추가  商品の追加
            when "2" then printf("売り出し：%d円\n",$sale)
                          return management()
        end
        
    end


    def product_add()
        puts "\n-----------------------------------------------------------"
        #자판기 재고 추가
        #自動販売機の商品追加
        puts "商品の名前を入力してください。"
        add_product_name = gets.chomp   #추가상품 이름　追加商品の名前
        
        while add_product_name == ""
            add_product_name = gets.chomp
        end
        
        puts "商品の価格を入力してください。"
        add_product_price = gets.chomp  #추가상품 가격　追加商品の価格
        
        while add_product_price.to_i < 0
            add_product_price = gets.chomp
        end
        
        puts "商品の数を入力してください。"
        add_product_stock = gets.chomp  #추가상품 수량　追加商品の量
        
        while add_product_stock.to_i <= 0
            add_product_stock = gets.chomp
        end
        
        i = 0
        
        product_name_check = false  #기존 상품이 존재할 경우 false 없는경우 true
                                    #既存の商品がある場合falseをない場合true
        while i<$product.length
        
            if add_product_name == $product[i][0]
                product_name_check = false
                
                if add_product_price.to_i == $product[i][1]
                    product_name_check = false
                    $product[i][2] += add_product_stock.to_i
                    break
                else
                    product_name_check = true
                end
            else
                product_name_check = true
            end
            
            i += 1;
            
        end
        
        if product_name_check == true
            $product << [add_product_name, add_product_price.to_i, add_product_stock.to_i]
        end
        
        return management()
    end


    def product_list()
        puts "\n-----------------------------------------------------------"
        #자판기 재고 리스트
        #自動販売機の商品リスト
        puts "商品リスト"
        i = 0;
        while i<$product.length
            if $inputPrice >= $product[i][1]
                if $product[i][2] <= 0
                    puts "#{i+1}. 商品:#{$product[i][0]} 価格:#{$product[i][1]}円 在庫:#{$product[i][2]} 購入不可能"
                else
                    puts "#{i+1}. 商品:#{$product[i][0]} 価格:#{$product[i][1]}円 在庫:#{$product[i][2]} 購入可能"
                end
                i += 1;
            elsif $inputPrice < $product[i][1]
                puts "#{i+1}. 商品:#{$product[i][0]} 価格:#{$product[i][1]}円 在庫:#{$product[i][2]} 購入不可能"
                i += 1;
            end
        end
        
    end
    
    def product_list_management()
        puts "\n-----------------------------------------------------------"
        #자판기 재고 리스트 관리
        #自動販売機の商品リスト管理
        puts "商品リスト"
        i = 0;
        while i<$product.length
        
            puts "#{i+1}. 商品:#{$product[i][0]} 価格:#{$product[i][1]}円 在庫:#{$product[i][2]}"
            i += 1;
            
        end
        
    end
end


vendingMachine = Vending_machine.new()
vendingMachine.menu()
