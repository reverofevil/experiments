grammar = _ rules:rule+ { return {type: 'Grammar', rules} }
rule = union / sequence
union = name:ident ":" _ cases:ident+ ";" _ { return {type: 'Union', name, cases} }
sequence = name:ident "=" _ terms:part+ ";" _ { return {type: 'Sequence', name, terms} }
part = field:field? stringy:"$"? term:term suffix:suffix? { return {type: 'Part', field, stringy, term, suffix} }
field = name:ident ":" { return {type: 'Field', name} }
suffix = suffix:[+*?] _ { return {type: 'Suffix', suffix} }
term = ref / klass / string1 / string2
ref = name:ident { return {type: 'Ref', name} }
klass = "[" inverted:inverted? parts:classPart* "]" _ { return {type: 'Klass', inverted, parts} }
inverted = "^" { return {type: 'Inverted'} }
classPart = range / single 
range = from:classChar "-" to:classChar { return {type: 'Range', from, to} }
single = char:classChar { return {type: 'Single', char} }
classChar = classCharEscape / classCharSimple
classCharSimple = char:[^\\\[\]] { return {type: 'ClassCharSimple', char} }
classCharEscape = "\\" char:[\\\[\]rnt] { return {type: 'ClassCharEscape', char} }
string1 = "'" chars:string1Char* "'" _ { return {type: 'String1', chars} }
string1Char = string1CharEscape / string1CharSimple;
string1CharSimple = char:[^'\\\r\n\t] { return {type: 'String1CharSimple', char} }
string1CharEscape = "\\" char:[\'\\rnt] { return {type: 'String1CharEscape', char} }
string2 = '"' chars:string2Char* '"' _ { return {type: 'String2', chars} }
string2Char = string2CharEscape / string2CharSimple
string2CharSimple = char:[^"\\\r\n\t] { return {type: 'String2CharSimple', char} }
string2CharEscape = "\\" char:[\"\\rnt] { return {type: 'String2CharEscape', char} }
ident = name:$identName _ { return {type: 'Ident', name} }
identName = [a-zA-Z_] [a-zA-Z0-9_]* { return {type: 'IdentName'} }
_ = [ \t\r\n]* { return { type: '_' } }