ClassFile {
    magic = Magic, 
    minver = MinorVersion {numMinVer = 0}, 
    maxver = MajorVersion {numMaxVer = 52}, 
    count_cp = 15, 
    array_cp = [
                 MethodRef_Info {tag_cp = TagMethodRef, index_name_cp = 3, index_nameandtype_cp = 12, desc = ""},
                 Class_Info {tag_cp = TagClass, index_cp = 13, desc = ""},
                 Class_Info {tag_cp = TagClass, index_cp = 14, desc = ""},
                 Utf8_Info {tag_cp = TagUtf8, tam_cp = 6, cad_cp = "<init>", desc = ""},
                 Utf8_Info {tag_cp = TagUtf8, tam_cp = 3, cad_cp = "()V", desc = ""},
                 Utf8_Info {tag_cp = TagUtf8, tam_cp = 4, cad_cp = "Code", desc = ""},
                 Utf8_Info {tag_cp = TagUtf8, tam_cp = 15, cad_cp = "LineNumberTable", desc = ""},
                 Utf8_Info {tag_cp = TagUtf8, tam_cp = 7, cad_cp = "doStuff", desc = ""},
                 Utf8_Info {tag_cp = TagUtf8, tam_cp = 13, cad_cp = "StackMapTable", desc = ""},
                 Utf8_Info {tag_cp = TagUtf8, tam_cp = 10, cad_cp = "SourceFile", desc = ""},
                 Utf8_Info {tag_cp = TagUtf8, tam_cp = 15, cad_cp = "SwitchCase.java", desc = ""},
                 NameAndType_Info {tag_cp = TagNameAndType, index_name_cp = 4, index_descr_cp = 5, desc = ""},
                 Utf8_Info {tag_cp = TagUtf8, tam_cp = 10, cad_cp = "SwitchCase", desc = ""},
                 Utf8_Info {tag_cp = TagUtf8, tam_cp = 16, cad_cp = "java/lang/Object", desc = ""}
               ], 
    acfg = AccessFlags [32], this = ThisClass {index_th = 2}, super = SuperClass {index_sp = 3}, count_interfaces = 0, array_interfaces = [], count_fields = 0, array_fields = [], count_methods = 2, array_methods = [Method_Info {af_mi = AccessFlags [], index_name_mi = 4, index_descr_mi = 5, tam_mi = 1, array_attr_mi = [AttributeCode {index_name_attr = 6, tam_len_attr = 29, len_stack_attr = 1, len_local_attr = 1, tam_code_attr = 5, array_code_attr = [42,183,0,1,177], tam_ex_attr = 0, array_ex_attr = [], tam_atrr_attr = 1, array_attr_attr = [AttributeLineNumberTable {index_name_attr = 7, tam_len_attr = 6, tam_table_attr = 1, array_line_attr = [(0,1)]}]}]},Method_Info {af_mi = AccessFlags [], index_name_mi = 8, index_descr_mi = 5, tam_mi = 1, array_attr_mi = [AttributeCode {index_name_attr = 6, tam_len_attr = 111, len_stack_attr = 1, len_local_attr = 3, tam_code_attr = 41, array_code_attr = [8,60,27,171,0,0,0,35,0,0,0,2,0,0,0,1,0,0,0,25,0,0,0,2,0,0,0,30,6,61,167,0,10,5,61,167,0,5,3,61,177], tam_ex_attr = 0, array_ex_attr = [], tam_atrr_attr = 2, array_attr_attr = [AttributeLineNumberTable {index_name_attr = 7, tam_len_attr = 34, tam_table_attr = 8, array_line_attr = [(0,4),(2,6),(28,7),(30,8),(33,9),(35,10),(38,11),(40,13)]},AttributeGeneric {index_name_attr = 9, tam_len_attr = 12, rest_attr = "\NUL\EOT\252\NUL\FS\SOH\EOT\EOT\252\NUL\SOH\SOH"}]}]}], count_attributes = 1, array_attributes = [AttributeSourceFile {index_name_attr = 10, tam_len_attr = 2, index_src_attr = 11}]}