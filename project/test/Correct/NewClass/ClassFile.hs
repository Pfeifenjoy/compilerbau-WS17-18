-- A
ClassFile {
    magic = Magic, 
    minver = MinorVersion {numMinVer = 0}, 
    maxver = MajorVersion {numMaxVer = 52}, 
    count_cp = 15, 
    array_cp = [
                MethodRef_Info {tag_cp = TagMethodRef, index_name_cp = 3, index_nameandtype_cp = 12, desc = ""},
                Class_Info {tag_cp = TagClass, index_cp = 13, desc = ""},
                Class_Info {tag_cp = TagClass, index_cp = 14, desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 1, cad_cp = "a", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 1, cad_cp = "I", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 6, cad_cp = "<init>", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 3, cad_cp = "()V", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 4, cad_cp = "Code", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 15, cad_cp = "LineNumberTable", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 10, cad_cp = "SourceFile", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 13, cad_cp = "NewClass.java", desc = ""},
                NameAndType_Info {tag_cp = TagNameAndType, index_name_cp = 6, index_descr_cp = 7, desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 1, cad_cp = "A", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 16, cad_cp = "java/lang/Object", desc = ""}
               ], 
    acfg = AccessFlags [32], this = ThisClass {index_th = 2}, super = SuperClass {index_sp = 3}, count_interfaces = 0, array_interfaces = [], count_fields = 1, array_fields = [Field_Info {af_fi = AccessFlags [], index_name_fi = 4, index_descr_fi = 5, tam_fi = 0, array_attr_fi = []}], count_methods = 1, array_methods = [Method_Info {af_mi = AccessFlags [], index_name_mi = 6, index_descr_mi = 7, tam_mi = 1, array_attr_mi = [AttributeCode {index_name_attr = 8, tam_len_attr = 29, len_stack_attr = 1, len_local_attr = 1, tam_code_attr = 5, array_code_attr = [42,183,0,1,177], tam_ex_attr = 0, array_ex_attr = [], tam_atrr_attr = 1, array_attr_attr = [AttributeLineNumberTable {index_name_attr = 9, tam_len_attr = 6, tam_table_attr = 1, array_line_attr = [(0,1)]}]}]}], count_attributes = 1, array_attributes = [AttributeSourceFile {index_name_attr = 10, tam_len_attr = 2, index_src_attr = 11}]}

-- B
ClassFile {
    magic = Magic, 
    minver = MinorVersion {numMinVer = 0}, 
    maxver = MajorVersion {numMaxVer = 52}, 
    count_cp = 21, 
    array_cp = [
                MethodRef_Info {tag_cp = TagMethodRef, index_name_cp = 6, index_nameandtype_cp = 14, desc = ""},
                Class_Info {tag_cp = TagClass, index_cp = 15, desc = ""},
                MethodRef_Info {tag_cp = TagMethodRef, index_name_cp = 2, index_nameandtype_cp = 14, desc = ""},
                FieldRef_Info {tag_cp = TagFieldRef, index_name_cp = 2, index_nameandtype_cp = 16, desc = ""},
                Class_Info {tag_cp = TagClass, index_cp = 17, desc = ""},
                Class_Info {tag_cp = TagClass, index_cp = 18, desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 6, cad_cp = "<init>", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 3, cad_cp = "()V", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 4, cad_cp = "Code", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 15, cad_cp = "LineNumberTable", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 7, cad_cp = "doStuff", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 10, cad_cp = "SourceFile", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 13, cad_cp = "NewClass.java", desc = ""},
                NameAndType_Info {tag_cp = TagNameAndType, index_name_cp = 7, index_descr_cp = 8, desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 1, cad_cp = "A", desc = ""},
                NameAndType_Info {tag_cp = TagNameAndType, index_name_cp = 19, index_descr_cp = 20, desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 1, cad_cp = "B", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 16, cad_cp = "java/lang/Object", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 1, cad_cp = "a", desc = ""},
                Utf8_Info {tag_cp = TagUtf8, tam_cp = 1, cad_cp = "I", desc = ""}
               ], 
    acfg = AccessFlags [32], this = ThisClass {index_th = 5}, super = SuperClass {index_sp = 6}, count_interfaces = 0, array_interfaces = [], count_fields = 0, array_fields = [], count_methods = 2, array_methods = [Method_Info {af_mi = AccessFlags [], index_name_mi = 7, index_descr_mi = 8, tam_mi = 1, array_attr_mi = [AttributeCode {index_name_attr = 9, tam_len_attr = 29, len_stack_attr = 1, len_local_attr = 1, tam_code_attr = 5, array_code_attr = [42,183,0,1,177], tam_ex_attr = 0, array_ex_attr = [], tam_atrr_attr = 1, array_attr_attr = [AttributeLineNumberTable {index_name_attr = 10, tam_len_attr = 6, tam_table_attr = 1, array_line_attr = [(0,5)]}]}]},Method_Info {af_mi = AccessFlags [], index_name_mi = 11, index_descr_mi = 8, tam_mi = 1, array_attr_mi = [AttributeCode {index_name_attr = 9, tam_len_attr = 52, len_stack_attr = 2, len_local_attr = 4, tam_code_attr = 16, array_code_attr = [187,0,2,89,183,0,3,76,43,180,0,4,61,1,78,177], tam_ex_attr = 0, array_ex_attr = [], tam_atrr_attr = 1, array_attr_attr = [AttributeLineNumberTable {index_name_attr = 10, tam_len_attr = 18, tam_table_attr = 4, array_line_attr = [(0,8),(8,9),(13,10),(15,11)]}]}]}], count_attributes = 1, array_attributes = [AttributeSourceFile {index_name_attr = 12, tam_len_attr = 2, index_src_attr = 13}]}









