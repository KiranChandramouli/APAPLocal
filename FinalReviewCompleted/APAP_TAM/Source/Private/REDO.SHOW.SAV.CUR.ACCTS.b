* @ValidationCode : MjoxOTcxMTAxNTU3OkNwMTI1MjoxNjgyNDk3ODk1NTU4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 14:01:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.SHOW.SAV.CUR.ACCTS(FIN.ARR)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By :
* Program Name : REDO.NOFILE.AI.DROP.DOWN.ENQ
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry REDO.SAV.ACCOUNT.LIST
* Linked with : Enquiry REDO.SAV.ACCOUNT.LIST  as BUILD routine
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*01/11/11       PACS00146410            PRABHU N                MODIFICAION
*
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           VM TO @VM,IF CONDITION ADDED
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION         CALL routine format modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT

    GOSUB INITIALISE
    GOSUB FORM.ACCT.ARRAY

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------


    F.CUSTOMER.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'

    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    CALL OPF(FN.ACC,F.ACC)

    FN.AZ = 'F.AZ.ACCOUNT'
    F.AZ = ''
    CALL OPF(FN.AZ,F.AZ)

    Y.VAR.EXT.CUSTOMER = ''
    Y.VAR.EXT.ACCOUNTS=''

    Y.FIELD.COUNT = ''
    ACCT.REC = ''
    LOAN.FLG = ''
    DEP.FLG = ''
    AZ.REC = ''
    R.ACC = ''
    LREF.APP='ACCOUNT'
    LREF.FIELDS='L.AC.STATUS1':@VM:'L.AC.AV.BAL'
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS) ;*MANUAL R22 CODE CONVERSION
    ACCT.STATUS.POS=LREF.POS<1,1>
    ACCT.OUT.BAL.POS=LREF.POS<1,2>

    CUSTOMER.ID = System.getVariable('EXT.CUSTOMER')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION - START
        CUSTOMER.ID = ""
    END ;*AUTO R22 CODE CONVERSION - END

RETURN
******************
FORM.ACCT.ARRAY:
*****************


    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER.ID,ACCT.REC,F.CUSTOMER.ACCOUNT,CUST.ERR)

    LOOP
        REMOVE ACCT.ID FROM ACCT.REC SETTING ACCT.POS
    WHILE ACCT.ID:ACCT.POS



        ACC.ERR= ''
        CALL F.READ(FN.ACC,ACCT.ID,R.ACC,F.ACC,ACC.ERR)
        IF NOT(ACC.ERR) THEN
            CUR.ACCT.STATUS=R.ACC<AC.LOCAL.REF><1,ACCT.STATUS.POS>
            IF CUR.ACCT.STATUS EQ 'ACTIVE' THEN

                GOSUB CHECK.LOAN.ACC
                GOSUB CHECK.AZ.ACC

                IF (LOAN.FLG EQ '1') AND (DEP.FLG EQ '1') THEN

                    FIN.ARR<-1> = ACCT.ID:"@":CUSTOMER.ID
                END
            END
        END
    REPEAT

RETURN
******************
CHECK.LOAN.ACC:
******************

    ARR.ID = R.ACC<AC.ARRANGEMENT.ID>
    IF ARR.ID EQ '' THEN

        LOAN.FLG = 1
    END

RETURN

*******************
CHECK.AZ.ACC:
******************

    CALL F.READ(FN.AZ,ACCT.ID,AZ.REC,F.AZ,AZ.ERR)

    IF NOT(AZ.REC) THEN
        DEP.FLG = 1

    END
RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
