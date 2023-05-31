* @ValidationCode : MjotMTE2NzI3NTU4OTpVVEYtODoxNjg1NTMwMzMyMDA0OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 16:22:12
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CUSTOMER.NAU(Y.FINAL.ARRAY)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Pradeep M
* Program Name : REDO.E.CUSTOMER.NAU
*-----------------------------------------------------------------------------
* Description :Built routine to assign value to set variable
* Linked with :
* In Parameter :
* Out Parameter :
*
**DATE          DEVELOPER           ODR              VERSION
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM and ++ to +=
* 11-APRIL-2023      Harsha                R22 Manual Conversion - Added APAP.REDOENQ
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    $INSERT I_F.USER
    $INSERT I_F.CUSTOMER

    GOSUB PRE.PROCESS

    IF R.REDO.ACCT.EXCE.RBHP THEN
        GOSUB OPEN.PROCESS
        GOSUB PROCESS
    END

RETURN

*----------*
PRE.PROCESS:
*----------*

    FN.REDO.ACCT.EXCE.RBHP = 'F.REDO.ACCT.EXCE.RBHP'
    F.REDO.ACCT.EXCE.RBHP = ''
    CALL OPF(FN.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP)

    GOSUB CHECK.ANY.RECORDS.AVAILABLE     ;* CONDITION TO CHECK IS THERE ANY RECORDS AVAILABLE FOR APPROVAL

RETURN

*-----------
OPEN.PROCESS:
*-----------

    FN.CUSTOMER.NAU = 'F.CUSTOMER$NAU'
    F.CUSTOMER.NAU  = ''
    CALL OPF(FN.CUSTOMER.NAU,F.CUSTOMER.NAU)

    LREF.APP = 'CUSTOMER'
    LREF.FIELDS = 'L.CU.TIPO.CL':@VM:'L.CU.CIDENT':@VM:'L.CU.ACTANAC':@VM:'L.CU.NOUNICO':@VM:'L.CU.RNC'
    LOCAL.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LOCAL.REF.POS)

    POS.L.CU.TIPO.CL = LOCAL.REF.POS<1,1>
    POS.L.CU.CIDENT  = LOCAL.REF.POS<1,2>
    POS.L.CU.ACTANAC  = LOCAL.REF.POS<1,3>
    POS.L.CU.NOUNICO = LOCAL.REF.POS<1,4>
    POS.L.CU.RNC     = LOCAL.REF.POS<1,5>

    APAP.REDOENQ.redoEFormSelStmt(FN.CUSTOMER.NAU, '', '', SEL.CUST.CMD)   ;*R22 Manual Conversion - Added APAP.REDOENQ

    IF D.RANGE.AND.VALUE THEN
        SEL.CUST.CMD := ' AND CUSTOMER.TYPE NE PROSPECT'
    END
    IF NOT(D.RANGE.AND.VALUE) THEN
        SEL.CUST.CMD := ' WITH CUSTOMER.TYPE NE PROSPECT'
    END

    CALL EB.READLIST(SEL.CUST.CMD,SEL.CUST.LIST,'',NO.OF.CUST.REC,SEL.CUST.ERR)

RETURN

*----------------------
PROCESS:
*----------------------

    Y.FINAL.DATA = ''

    IF R.REDO.ACCT.EXCE.RBHP THEN

        Y.DATA.CNT = DCOUNT(SEL.CUST.LIST,@FM)
        CNT = 1
        LOOP

        WHILE CNT LE Y.DATA.CNT
            Y.VAL = SEL.CUST.LIST<CNT>
            LOCATE Y.VAL IN R.REDO.ACCT.EXCE.RBHP SETTING POS.L THEN

                CALL F.READ(F.CUSTOMER.NAU,Y.VAL,R.CUSTOMER.NAU,F.CUSTOMER.NAU,CUSTOMER.ERR)
                Y.L.CU.TIPO.CL = R.CUSTOMER.NAU<EB.CUS.LOCAL.REF,POS.L.CU.TIPO.CL>
                Y.L.CU.CIDENT  = R.CUSTOMER.NAU<EB.CUS.LOCAL.REF,POS.L.CU.CIDENT>
                Y.LEGAL.ID     = R.CUSTOMER.NAU<EB.CUS.LEGAL.ID>
                Y.L.CU.ACTANAC = R.CUSTOMER.NAU<EB.CUS.LOCAL.REF,POS.L.CU.ACTANAC>
                Y.L.CU.NOUNICO = R.CUSTOMER.NAU<EB.CUS.LOCAL.REF,POS.L.CU.NOUNICO>
                Y.L.CU.RNC     = R.CUSTOMER.NAU<EB.CUS.LOCAL.REF,POS.L.CU.RNC>
                Y.GIVEN.NAMES  = R.CUSTOMER.NAU<EB.CUS.GIVEN.NAMES>
                Y.FAMILY.NAME  = R.CUSTOMER.NAU<EB.CUS.FAMILY.NAME>
                Y.NAME.1       = R.CUSTOMER.NAU<EB.CUS.NAME.1>
                Y.NAME.2       = R.CUSTOMER.NAU<EB.CUS.NAME.2>
                Y.OTHER.OFFICER= R.CUSTOMER.NAU<EB.CUS.OTHER.OFFICER>
                Y.ACCOUNT.OFFICER = R.CUSTOMER.NAU<EB.CUS.ACCOUNT.OFFICER>
                Y.CR.PROFILE.TYPE = R.CUSTOMER.NAU<EB.CUS.CR.PROFILE.TYPE>
                Y.RECORD.STATUS   = R.CUSTOMER.NAU<EB.CUS.RECORD.STATUS>
                Y.INPUTTER        = R.CUSTOMER.NAU<EB.CUS.INPUTTER>

                Y.FINAL.DATA  = Y.VAL:'*':Y.L.CU.TIPO.CL:'*':Y.L.CU.CIDENT:'*':Y.LEGAL.ID:'*':Y.L.CU.ACTANAC:'*':Y.L.CU.NOUNICO
                Y.FINAL.DATA := '*':Y.L.CU.RNC:'*':Y.GIVEN.NAMES:'*':Y.FAMILY.NAME:'*':Y.NAME.1:'*':Y.NAME.2:'*':Y.OTHER.OFFICER
                Y.FINAL.DATA := '*':Y.ACCOUNT.OFFICER:'*':Y.CR.PROFILE.TYPE:'*':Y.RECORD.STATUS:'*':Y.INPUTTER
                Y.FINAL.ARRAY<-1> = Y.FINAL.DATA

            END
            CNT += 1
        REPEAT
    END

    SEL.CUST.LIST = ''          ;* Added for PACS00245167
    Y.ARRAY = ''      ;* Added for PACS00245167
RETURN

*--------------------------*
CHECK.ANY.RECORDS.AVAILABLE:
*--------------------------*

    Y.ID = 'CUSTOMER-':ID.COMPANY
    SEL.RBHP.LIST = '' ; ERR.RBHP.CUS = '' ; R.REDO.ACCT.EXCE.RBHP = ''
    SEL.CUS.CMD = 'SELECT ':FN.REDO.ACCT.EXCE.RBHP:' WITH @ID LIKE ':Y.ID:'...'
    CALL EB.READLIST(SEL.CUS.CMD,SEL.RBHP.LIST,'',NO.OF.REC,ERR.RBHP.CUS)

    IF SEL.RBHP.LIST THEN
        LOOP
            REMOVE Y.RBHP.ID FROM SEL.RBHP.LIST SETTING RBHP.POS
        WHILE Y.RBHP.ID:RBHP.POS
            R.REDO.ACCT.EXCE.RBHP<-1> = FIELD(Y.RBHP.ID,'-',3)
        REPEAT
    END

RETURN

*---------------------
END
