ClassFile {
    magic = Magic, 
    minver = MinorVersion {numMinVer = 0}, 
    maxver = MajorVersion {numMaxVer = 52}, 
    count_cp = 14, 
    array_cp = [
                MethodRef_Info {tag_cp = TagMethodRef, index_name_cp = 3, index_nameandtype_cp = 11, desc = ""},
                Class_Info {tag_cp = TagClass, index_cp = 12, desc = ""},
                Class_Info {tag_cp = TagClass, index_cp = 13, desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 6, cad_cp = "<init>", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 3, cad_cp = "()V", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 4, cad_cp = "Code", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 15, cad_cp = "LineNumberTable", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 7, cad_cp = "doStuff", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 10, cad_cp = "SourceFile", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 12, cad_cp = "ShortIf.java", desc = ""},
                NameAndType_Info {tag_cp = TagNameAndType, index_name_cp = 4, index_descr_cp = 5, desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 7, cad_cp = "ShortIf", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 16, cad_cp = "java/lang/Object", desc = ""}
               ], 
    acfg = AccessFlags [32], this = ThisClass {index_th = 2}, super = SuperClass {index_sp = 3}, count_interfaces = 0, array_interfaces = [], count_fields = 0, array_fields = [], count_methods = 2, array_methods = [Method_Info {af_mi = AccessFlags [], index_name_mi = 4, index_descr_mi = 5, tam_mi = 1, array_attr_mi = [AttributeCode {index_name_attr = 6, tam_len_attr = 29, len_stack_attr = 1, len_local_attr = 1, tam_code_attr = 5, array_code_attr = [42,183,0,1,177], tam_ex_attr = 0, array_ex_attr = [], tam_atrr_attr = 1, array_attr_attr = [AttributeLineNumberTable {index_name_attr = 7, tam_len_attr = 6, tam_table_attr = 1, array_line_attr = [(0,1)]}]}]},Method_Info {af_mi = AccessFlags [], index_name_mi = 8, index_descr_mi = 5, tam_mi = 1, array_attr_mi = [AttributeCode {index_name_attr = 6, tam_len_attr = 31, len_stack_attr = 1, len_local_attr = 2, tam_code_attr = 3, array_code_attr = [4,60,177], tam_ex_attr = 0, array_ex_attr = [], tam_atrr_attr = 1, array_attr_attr = [AttributeLineNumberTable {index_name_attr = 7, tam_len_attr = 10, tam_table_attr = 2, array_line_attr = [(0,3),(2,4)]}]}]}], count_attributes = 1, array_attributes = [AttributeSourceFile {index_name_attr = 9, tam_len_attr = 2, index_src_attr = 10}]}