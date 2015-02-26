#!/usr/bin/env xcrun swift

import Foundation

let input_string = Process.arguments[1]

func toPolsk(string : String) -> [String]{ // запись в обратную польскую натацию
    
    var List = [String]()
    var answer = [String]()
    var startString = string + "="
    
    var ind = startString.startIndex // 
    startString.endIndex
    
    var k = 0
    
    for s in startString {
        if s == "(" {
            k++
        }
        if s == ")" {
            k--
        }
    }
    
    if k != 0 {println("Error! counts of ( and ) not right"); exit(0)} // проверка количества скобок
    
    while (ind < startString.endIndex){
        
        if startString[ind] == " " {} // если попался пробел, пропускаем
        
        else
            if ((startString[ind] >= "0" && startString[ind] <= "9") || startString[ind] == "." || startString[ind] == "P" || startString[ind] == "E") // добавление чисел
            {
                var ind2 = ind
                startString[ind]
                ind2.successor()
                if startString[ind] == "P" { // число пи
                    if (startString[++ind] != "I" && startString[++ind] != "i" ) {println("Error! unknown constant"); exit(0)}
                    answer.append("3.1415926535");
                } else
                    if startString[ind] == "E" {answer.append("2.7182818284"); } // число Е
                    else
                    {   // считывание числа
                        while (ind2 < startString.endIndex && (startString[ind2] >= "0" && startString[ind2] <= "9") || startString[ind2] == "." ){
                            ind2++
                          //  if (ind2 >= startString.endIndex) {break}
                    }
                        answer.append(startString.substringWithRange(Range<String.Index>(start: ind, end: ind2)))
                        ind = ind2.predecessor()
                        if (ind >= startString.endIndex) {break }
                }
            } // наборы правил для добавления в List и answer
            else if  (startString[ind] == "(" || List.count == 0) && startString[ind] != "s" && startString[ind] != "c" && startString[ind] != "e"{
                List.append(String(startString[ind]))
            }
            else if (startString[ind] == "+" || startString[ind] == "-" || startString[ind] == "*" || startString[ind] == "/") && List.last == "(" {
                List.append(String(startString[ind]))
            }
            else if (startString[ind] == "+" || startString[ind] == "-") && List.last != "(" {
                while (List.last != "(" && List.count != 0 && List.last != "sin" && List.last != "cos" && List.last != "exp"){
                    let temp = List.last
                    List.removeLast()
                    answer.append(temp!)
                }
                List.append(String(startString[ind]))
            }
            else if (startString[ind] == "*" || startString[ind] == "/") && (List.last == "*" || List.last == "/"){
                let temp = List.last
                List.removeLast()
                answer.append(temp!)
                List.append(String(startString[ind]))
            }
            else if (startString[ind] == "*" || startString[ind] == "/") && (List.last == "+" || List.last == "-" || List.last == "sin" || List.last == "cos" || List.last == "exp"){
                List.append(String(startString[ind]))
            }
            else if (startString[ind] == ")"){
                while (List.last != "(" && List.last != "sin" && List.last != "cos" && List.last != "exp"){
                    let temp = List.last
                    List.removeLast()
                    answer.append(temp!)
                }
                if List.last == "sin" {answer.append("sin")}
                if List.last == "cos" {answer.append("cos")}
                if List.last == "exp" {answer.append("exp")}
                List.removeLast()
            }
            else if (startString[ind] == "="){
                while (List.count != 0){
                    let temp = List.last
                    List.removeLast()
                    answer.append(temp!)
                }
            }
            else if (startString[ind] == "s" ){
                var ind2 = ind
                ind++
                if (startString[++ind2] != "i" && startString[++ind] != "n" )  {println("Error!"); exit(0)}
                ind++; ind++
                List.append("sin")
            }
            else if (startString[ind] == "c"){
                var ind2 = ind
                ind++
                if (startString[++ind2] != "o" && startString[++ind] != "s" )  {println("Error!"); exit(0)}
                ind++; ind++
                List.append("cos")
            }
            else if (startString[ind] == "e"){
                var ind2 = ind; ind++
                if (startString[++ind2] != "x" && startString[++ind] != "p" )  {println("Error!"); exit(0)}
                ind++; ind++
                List.append("exp")
            }
            else {
                println("Error! unknown constant");
                exit(0)
        }
        ind++
    }
    return answer
}

func culc(arr : [String]) -> Double{ // вычисление значения польской нотации
    
    var Stack = [Double]()
    
    for i in arr {
        let tmp = i.startIndex
        if i[tmp] >= "0" && i[tmp] <= "9"  {
            Stack.append((i as NSString).doubleValue)
        }else if i[tmp] == "+" {
            let s1 = Stack[Stack.count-1]
            let s2 = Stack[Stack.count-2]
            Stack.removeLast()
            Stack.removeLast()
            Stack.append(s1+s2)
        } else if i[tmp] == "-" {
            let s1 = Stack[Stack.count-1]
            let s2 = Stack[Stack.count-2]
            Stack.removeLast()
            Stack.removeLast()
            Stack.append(s2-s1)
        } else if i[tmp] == "*" {
            let s1 = Stack[Stack.count-1]
            let s2 = Stack[Stack.count-2]
            Stack.removeLast()
            Stack.removeLast()
            Stack.append(s1*s2)
        } else if i[tmp] == "/" {
            let s1 = Stack[Stack.count-1]
            let s2 = Stack[Stack.count-2]
            Stack.removeLast()
            Stack.removeLast()
            Stack.append(s2/s1)
        } else if i[tmp] == "e" {
            let s1 = Stack[Stack.count-1]
            Stack.removeLast()
            Stack.append(pow(2.71828182845904, s1))
        } else if i[tmp] == "s" {
            let s1 = Stack[Stack.count-1]
            Stack.removeLast()
            Stack.append(sin(s1))
        } else if i[tmp] == "c" {
            let s1 = Stack[Stack.count-1]
            Stack.removeLast()
            Stack.append(cos(s1))
        }
        
    }
    
    return Stack.last!
}



println(NSString(format:"%.5f", culc(toPolsk(input_string))))


