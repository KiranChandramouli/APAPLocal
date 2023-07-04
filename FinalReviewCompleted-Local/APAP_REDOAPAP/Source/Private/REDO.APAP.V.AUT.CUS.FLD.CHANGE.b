* @ValidationCode : MjotODY4ODIxNjkxOkNwMTI1MjoxNjgxODE0MTA0NTUxOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 16:05:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.V.AUT.CUS.FLD.CHANGE
*-----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* It is a Auth Routine attached in Version control of customer
* If a customer record is amended the amended fields and values are written in local
* template
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                 Reference
* 06-SEP-10    Kishore.SP            INITIALVERSION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM , ++ to +=
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.LOCAL.REF.TABLE
    $INSERT I_F.LOCAL.TABLE
    $INSERT I_F.REDO.APAP.CUS.FIELD.CHANGE
*-----------------------------------------------------------------------------
    GOSUB OPEN.FILES
    GOSUB PROCESS

    IF Y.FLD.NAMES THEN
        GOSUB WRITE.TO.TEMPLATE
    END

RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*----------
*Open the necessary files
*
    FN.STANDARD.SELECTION = 'F.STANDARD.SELECTION'
    F.STANDARD.SELECTION  = ''
    CALL OPF(FN.STANDARD.SELECTION,F.STANDARD.SELECTION)
*
    FN.LOCAL.REF.TABLE    = 'F.LOCAL.REF.TABLE'
    F.LOCAL.REF.TABLE     = ''
    CALL OPF(FN.LOCAL.REF.TABLE,F.LOCAL.REF.TABLE)
*
    FN.LOCAL.TABLE        = 'F.LOCAL.TABLE'
    F.LOCAL.TABLE         = ''
    CALL OPF(FN.LOCAL.TABLE,F.LOCAL.TABLE)
*
    FN.REDO.APAP.CUS.FIELD.CHANGE  = 'F.REDO.APAP.CUS.FIELD.CHANGE'
    F.REDO.APAP.CUS.FIELD.CHANGE   = ''
    CALL OPF(FN.REDO.APAP.CUS.FIELD.CHANGE,F.REDO.APAP.CUS.FIELD.CHANGE)
*
    FN.REDO.CUS.DEM.CH.DATE='F.REDO.CUS.DEM.CH.DATE'
    F.REDO.CUS.DEM.CH.DATE =''
    CALL OPF(FN.REDO.CUS.DEM.CH.DATE,F.REDO.CUS.DEM.CH.DATE)

    Y.FLD.NAMES = ''
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*--------
* Check the curr no and if equals to '1' then skip the record
* if curr eq '1' it is a newly created customer record
*
    Y.CURR.NO = R.NEW(EB.CUS.CURR.NO)
*
    IF Y.CURR.NO EQ '1' THEN
        RETURN
    END
*
    GOSUB GET.CORE.FIELDS.CHANGE

    IF Y.FLD.NAMES THEN
        GOSUB GET.LOCAL.FIELDS.CHANGE
    END

RETURN
*-----------------------------------------------------------------------------
GET.CORE.FIELDS.CHANGE:
*-----------------------
* Standard Selection record of customer is read
*

    Y.AUDIT.FIELD.NAMES =  'AUDIT.DATE.TIME':@VM:'AUDITOR.CODE':@VM:'RECORD.STATUS':@VM:'OVERRIDE':@VM:'DEPT.CODE'
    Y.AUDIT.FIELD.NAMES : =  @VM:'CO.CODE':@VM:'AUTHORISER':@VM:'INPUTTER':@VM:'DATE.TIME':@VM:'CURR.NO'

    STANDARD.SELECTION.ID  = 'CUSTOMER'
*
    R.STANDARD.SELECTION = ''
    CALL CACHE.READ(FN.STANDARD.SELECTION,STANDARD.SELECTION.ID,R.STANDARD.SELECTION,Y.SS.ERR)
*
    CALL GET.STANDARD.SELECTION.DETS('CUSTOMER',R.STANDARD.SELECTION)
*
    IF R.STANDARD.SELECTION NE '' THEN
        Y.CUS.FLD.COUNT  = EB.CUS.AUDIT.DATE.TIME
        Y.COUNT = 1
        LOOP
        WHILE Y.COUNT LE Y.CUS.FLD.COUNT
            TEST.R = R.OLD(Y.COUNT)
            TEST.N = R.NEW(Y.COUNT)
            IF R.OLD(Y.COUNT) NE R.NEW(Y.COUNT) THEN
                GOSUB GET.CORE.FIELD.NAME
            END
            Y.COUNT += 1 ;*R22 AUTO CODE CONVERSION
        REPEAT

    END

RETURN
*-----------------------------------------------------------------------------
GET.CORE.FIELD.NAME:
*-------------------
* Core routines is used to get the values
*
    CALL FIELD.NUMBERS.TO.NAMES(Y.COUNT,R.STANDARD.SELECTION,Y.FIELD.NAME,'','')

    IF Y.FIELD.NAME MATCHES Y.AUDIT.FIELD.NAMES ELSE
        Y.FLD.NAMES<-1> = Y.FIELD.NAME
    END
*
RETURN
*-----------------------------------------------------------------------------
GET.LOCAL.FIELDS.CHANGE:
*-----------------------
* Get the local reference table values
*
    LOCAL.REF.TABLE.ID = 'CUSTOMER'
*
    R.LOCAL.REF.TABLE.ID = ''
    CALL CACHE.READ(FN.LOCAL.REF.TABLE,LOCAL.REF.TABLE.ID,R.LOCAL.REF.TABLE,Y.LRT.ERR)
    Y.LOC.FLD.COUNT = DCOUNT(R.LOCAL.REF.TABLE<EB.LRT.LOCAL.TABLE.NO>,@VM)
*
    Y.LOC.COUNT = 1
    LOOP
    WHILE Y.LOC.COUNT LE Y.LOC.FLD.COUNT
        IF R.OLD(EB.CUS.LOCAL.REF)<1,Y.LOC.COUNT> NE R.NEW(EB.CUS.LOCAL.REF)<1,Y.LOC.COUNT> THEN
            GOSUB GET.LOC.FIELD.NAME
        END
        Y.LOC.COUNT += 1 ;* R22 AUTO CODE CONVERSION
    REPEAT
*
RETURN
*-----------------------------------------------------------------------------
GET.LOC.FIELD.NAME:
*------------------
* Get the local table values
*
    LOCAL.TABLE.ID = R.LOCAL.REF.TABLE<EB.LRT.LOCAL.TABLE.NO,Y.LOC.COUNT>
*
    R.LOCAL.TABLE = ''
    CALL CACHE.READ(FN.LOCAL.TABLE,LOCAL.TABLE.ID,R.LOCAL.TABLE,Y.LT.ERR)
    IF R.LOCAL.TABLE NE '' THEN
        Y.FLD.NAMES<-1> = R.LOCAL.TABLE<EB.LTA.SHORT.NAME,1>
    END
RETURN
*-----------------------------------------------------------------------------
WRITE.TO.TEMPLATE:
*----------------
* Write the value to the local template with id as customer ID
*
    GOSUB FIND.MULTI.LOCAL.REF
    REDO.APAP.CUS.FIELD.CHANGE.ID = ID.NEW
*
    CALL F.READ(FN.REDO.APAP.CUS.FIELD.CHANGE,REDO.APAP.CUS.FIELD.CHANGE.ID,R.REDO.APAP.CUS.FIELD.CHANGE,F.REDO.APAP.CUS.FIELD.CHANGE,Y.REDO.APAP.CUS.FIELD.CHANGE.ERR)
    R.REDO.APAP.CUS.FIELD.CHANGE<CUS.FLD.FLD.NAME>     = ''
    R.REDO.APAP.CUS.FIELD.CHANGE<CUS.FLD.DATE>         = ''
    R.REDO.APAP.CUS.FIELD.CHANGE<CUS.FLD.ACCT.OFFICER> = ''
    R.REDO.APAP.CUS.FIELD.CHANGE<CUS.FLD.OTHR.OFFICER> = ''
    R.REDO.APAP.CUS.FIELD.CHANGE<CUS.FLD.PERSON.TYPE>  = ''
    R.REDO.APAP.CUS.FIELD.CHANGE<CUS.FLD.INPUTER>      = ''
    CHANGE @FM TO @VM IN Y.FLD.NAMES
    R.REDO.APAP.CUS.FIELD.CHANGE<CUS.FLD.FLD.NAME>     = Y.FLD.NAMES
    R.REDO.APAP.CUS.FIELD.CHANGE<CUS.FLD.DATE>         = 20:R.NEW(EB.CUS.DATE.TIME)[1,6]
    R.REDO.APAP.CUS.FIELD.CHANGE<CUS.FLD.ACCT.OFFICER> = R.NEW(EB.CUS.ACCOUNT.OFFICER)
    R.REDO.APAP.CUS.FIELD.CHANGE<CUS.FLD.OTHR.OFFICER> = R.NEW(EB.CUS.CO.CODE)
    R.REDO.APAP.CUS.FIELD.CHANGE<CUS.FLD.PERSON.TYPE>  = R.NEW(EB.CUS.LOCAL.REF)<1,LOC.L.CU.TIPO.CL.POS>
    R.REDO.APAP.CUS.FIELD.CHANGE<CUS.FLD.INPUTER>      = R.NEW(EB.CUS.INPUTTER)
*
    CALL F.WRITE(FN.REDO.APAP.CUS.FIELD.CHANGE,REDO.APAP.CUS.FIELD.CHANGE.ID,R.REDO.APAP.CUS.FIELD.CHANGE)
    CALL F.READ(FN.REDO.CUS.DEM.CH.DATE,TODAY,R.REDO.CUS.DEM.CH.DATE,F.REDO.CUS.DEM.CH.DATE,ERR)
    LOCATE ID.NEW IN R.REDO.CUS.DEM.CH.DATE SETTING Y.CU.DEM.POS ELSE
        R.REDO.CUS.DEM.CH.DATE<-1>=ID.NEW
    END
    CALL F.WRITE(FN.REDO.CUS.DEM.CH.DATE,TODAY,R.REDO.CUS.DEM.CH.DATE)
*
RETURN
*-----------------------------------------------------------------------------
FIND.MULTI.LOCAL.REF:
*-------------------
* Find the local reference field positions
*
    APPL.ARRAY = 'CUSTOMER'
    FLD.ARRAY  = 'L.CU.TIPO.CL'
    FLD.POS    = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.CU.TIPO.CL.POS = FLD.POS<1,1>

RETURN
END
