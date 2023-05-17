SUBROUTINE MULTI.GET.LOC.REF(APPL.ARR,FIELDNAME.ARR,POS.ARR)
************************************************************************************
* This program can in a single run return the field positions of multiple
* local reference fields from either a single or across multiple applications
*
* This program accepts the following arguements
*
* Arguement 1 : APPL.ARR
* This is the array containing the name(s) of the application or multiple
* applications across which local reference field positions need to be
* obtained. The syntax for passing in the names of the applications is as
* follows
*
* Appl Name 1<Field Marker>Appl Name 2<Field Marker>etc
*
* Arguement 2 : FIELDNAME.ARR
* This is the array containing the name(s) of the actual local reference
* fields present inside either the single application or multiple applications
* for which the local reference field positions are to be returned. The syntax
* for passing in the names of the local reference field name(s) is as follows
*
* Appl1 LRef1<Value Marker>Appl1 LRef2.....<Field Marker>Appl2 LRef1
*
* Arguement 3 : POS.ARR
* This is the arguement that is returned to the calling program. This arguement
* is formatted in exactly the same way as the FIELDNAME.ARR arguement. This
* arguement will contain the field position(s) names of the local reference
* field(s) in the respective applications. The field positions are inserted
* into this array in exactly the same position(s) that it was encountered in
* the FIELDNAME.ARR. The values being returned in this array will be like
*
* Appl1 LRef1 Posn<Value Marker>Appl1 LRef2 Posn......<Field Marker> Appl2
* LRef1 Posn
***********************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDARD.SELECTION

MAIN:
    POS.ARR = ''
    FN.STANDARD.SELECTION = 'F.STANDARD.SELECTION'
    FP.STANDARD.SELECTION = ''
    CALL OPF(FN.STANDARD.SELECTION,FP.STANDARD.SELECTION)
*
    CNTR1 = DCOUNT(APPL.ARR,@FM)
    FOR I.VAR = 1 TO CNTR1
        APPL = APPL.ARR<I.VAR>
        CALL CACHE.READ(FN.STANDARD.SELECTION, APPL, REC.STORE, RVAL)
*
        USR.FIELD.NAME = REC.STORE<SSL.USR.FIELD.NAME>
        CHANGE @VM TO @FM IN USR.FIELD.NAME
*
        CNTR2 = DCOUNT(FIELDNAME.ARR<I.VAR>,@VM)
        FOR J.VAR = 1 TO CNTR2
            FIELDNAME = FIELDNAME.ARR<I.VAR,J.VAR>
            LOCATE FIELDNAME IN USR.FIELD.NAME<1> SETTING CPOS ELSE CPOS = ''
            USR.FIELD.VALUE = REC.STORE<SSL.USR.FIELD.NO,CPOS,1>
            IF CPOS NE '' THEN
                Y.ID.LOCREF.POSN = FIELD(USR.FIELD.VALUE,",",2)
                Y.ID.LOCREF.POSN = TRIM(FIELD(Y.ID.LOCREF.POSN,'>',1))
                POS.ARR<I.VAR,J.VAR>=Y.ID.LOCREF.POSN
            END
        NEXT J.VAR
    NEXT I.VAR
RETURN
END
