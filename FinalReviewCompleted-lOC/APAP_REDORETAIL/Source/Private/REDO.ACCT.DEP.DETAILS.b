* @ValidationCode : MjotMjA5ODUzNDA0MzpDcDEyNTI6MTY4MTI3NjU1NjU3NjpJVFNTOi0xOi0xOjg0NToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 845
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.ACCT.DEP.DETAILS(Y.ACC.ID)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.ACCT.DEP.DETAILS
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
* ------------    -----------           -------------            -----------------
* 22 OCT  2014    EGAMBARAM A            REPORT 55                Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                FM TO @FM, VM TO @VM
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.RELATION
    $INSERT I_F.CATEGORY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.REDO.AML.PARAM
    $INSERT I_REDO.ACCT.DEP.DETAILS.COMMON
    $INSERT I_F.REDO.H.TELLER.TXN.CODES
    $INSERT I_F.MNEMONIC.COMPANY
    $INSERT I_F.DATES

    GOSUB MAIN.PROCESS
*--------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*=============
*
    CALL INT.ACC(Y.ACC.ID,Y.T.FLG1)
    IF Y.T.FLG1 EQ '1' THEN
        RETURN
    END

    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF NOT(R.ACCOUNT) THEN
        RETURN
    END

    Y.INCOME.CATEG = R.ACCOUNT<AC.CATEGORY>

    LOCATE Y.INCOME.CATEG IN Y.TOTAL.CAT SETTING Y.INCOME.CATEG.POS THEN
        GOSUB MAIN.PROCESS.2
    END
***
RETURN
*--------------------------------------------------------------------------------------------------------
MAIN.PROCESS.2:
*==============
    CALL F.READ(FN.ACCT.ENT.LWORK.DAY,Y.ACC.ID,R.ACCT.ENT.LWORK.DAY,F.ACCT.ENT.LWORK.DAY,LWORK.ERR)
    YID.LIST = R.ACCT.ENT.LWORK.DAY

    LOOP
        REMOVE Y.STMT.ID FROM YID.LIST SETTING STMT.POS
    WHILE Y.STMT.ID : STMT.POS
        R.STMT.ENTRY = '' ; ERR.STMT.ENTRY = ''
*Tus Start
*    READ R.STMT.ENTRY FROM F.STMT.ENTRY,Y.STMT.ID THEN
        CALL F.READ(FN.STMT.ENTRY,Y.STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY,R.STMT.ENTRY.ERR)
        IF R.STMT.ENTRY THEN
* Tus End
        END ELSE
            R.STMT.ENTRY = ''
        END
        IF R.STMT.ENTRY<AC.STE.AMOUNT.LCY> GE Y.AMT THEN
            GOSUB DATA.PROCESS
        END
    REPEAT
*
RETURN
*--------------------------------------------------------------------------------------------------------
DATA.PROCESS:
*------------
    Y.AGENCY = R.STMT.ENTRY<AC.STE.COMPANY.CODE>
    Y.DATE = R.STMT.ENTRY<AC.STE.BOOKING.DATE>
    Y.TRANS.REF = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
    Y.CHECK.AC = FIELD(Y.TRANS.REF,'-',1)

    IF (Y.CHECK.AC EQ Y.ACC.ID) THEN
        RETURN
    END

    IF (Y.CHECK.AC EQ 'AZ') THEN
        RETURN
    END

    Y.CHK.AGENCY = FIELD(Y.TRANS.REF,'\',2)
    IF Y.CHK.AGENCY NE '' THEN
        CALL F.READ(FN.MNEMONIC.COMPANY,Y.CHK.AGENCY,R.MNEMONIC.COMPANY,F.MNEMONIC.COMPANY,MNE.ERROR)
        IF R.MNEMONIC.COMPANY THEN
            Y.AGENCY = R.MNEMONIC.COMPANY
        END
    END
    Y.INPUTTER = FIELD(R.STMT.ENTRY<AC.STE.INPUTTER>,'_',2,1)
    Y.AUTHORISER = FIELD(R.STMT.ENTRY<AC.STE.AUTHORISER>,'_',2,1)
    Y.AC.CATEGORY = R.ACCOUNT<AC.CATEGORY>
    CALL F.READ(FN.CATEGORY,Y.AC.CATEGORY,R.AC.CATEG,F.CATEGORY,CAT.ERR)
    Y.AC.CATEGORY = R.AC.CATEG<EB.CAT.DESCRIPTION,1>
    Y.AC.CURRENCY = R.ACCOUNT<AC.CURRENCY>
    Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
    Y.ACCOUNT.OFFICER = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    IF Y.AC.CURRENCY EQ LCCY THEN
        Y.TRANS.AMOUNT = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
    END ELSE
        Y.TRANS.AMOUNT = R.STMT.ENTRY<AC.STE.AMOUNT.FCY>
    END
*
    GOSUB GET.ACCOUNT.NAME
    GOSUB WRITE.PROCESS
*
RETURN
*--------------------------------------------------------------------------------------------------------
GET.ACCOUNT.NAME:
*----------------
    Y.ACC.NAMES = '' ; Y.CUS.NAME = '' ; Y.CUS.NAMES = ''
    R.CUSTOMER = '' ; ERR.CUSTOMER = ''
*Tus Start
*  READ R.CUSTOMER FROM F.CUSTOMER,Y.CUSTOMER THEN
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,R.CUSTOMER.ERR)
    IF R.CUSTOMER THEN
* Tus End
    END ELSE
        R.CUSTOMER = ''
    END
*
    IF (R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA") OR (R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR") THEN
        Y.CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END
    IF (R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA") THEN
        Y.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
    END
    IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
        Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
    END
*
    Y.RELATION.CODE = R.ACCOUNT<AC.RELATION.CODE>
    Y.REL.CNT = DCOUNT(Y.RELATION.CODE,@VM)
    Y.CNT = "1"
    LOOP
    WHILE Y.CNT LE Y.REL.CNT
        Y.REL.CODE = R.ACCOUNT<AC.RELATION.CODE,Y.CNT>
        Y.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER,Y.CNT>
        IF (Y.REL.CODE GE '500' AND Y.REL.CODE LE '529') THEN
            R.RELATION = '' ; ERR.RELATION = ''
            CALL F.READ(FN.RELATION,Y.REL.CODE,R.RELATION,F.RELATION,ERR.RELATION)
            Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>

            R.CUSTOMER1 = '' ; ERR.CUSTOMER1 = ''
*Tus Start
*      READ R.CUSTOMER1 FROM F.CUSTOMER,Y.JOINT.HOLDER THEN
            CALL F.READ(FN.CUSTOMER,Y.JOINT.HOLDER,R.CUSTOMER1,F.CUSTOMER,R.CUSTOMER1.ERR)
            IF R.CUSTOMER1 THEN
* Tus End
            END ELSE
                R.CUSTOMER1 = ''
            END
            Y.CUS.NAMES =  ''
            IF (R.CUSTOMER1<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA") OR (R.CUSTOMER1<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR") THEN
                Y.CUS.NAMES = R.CUSTOMER1<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER1<EB.CUS.FAMILY.NAME>
            END
            IF R.CUSTOMER1<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
                Y.CUS.NAMES = R.CUSTOMER1<EB.CUS.NAME.1,1>:" ":R.CUSTOMER1<EB.CUS.NAME.2,1>
            END
            IF R.CUSTOMER1<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "" THEN
                Y.CUS.NAMES = R.CUSTOMER1<EB.CUS.SHORT.NAME,1>
            END
            Y.ACC.NAMES<-1> = Y.CUS.NAME:'-':Y.REL.DESC:'-':Y.CUS.NAMES
        END
        Y.CNT += 1
    REPEAT
*
    CHANGE @FM TO @VM IN Y.ACC.NAMES

    IF Y.ACC.NAMES THEN
        Y.ACCOUNT.NAME = Y.ACC.NAMES
    END
    IF Y.CUS.NAME THEN
        Y.ACCOUNT.NAME = Y.CUS.NAME
    END
*
RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------------
WRITE.PROCESS:
*-------------
    CALL EB.DATE.FORMAT.DISPLAY(Y.DATE,Y.DATE.OUT,'','')
    R.FINAL.VAL = Y.AGENCY:",":Y.DATE.OUT:",":Y.ACCOUNT.OFFICER:",":Y.AC.CATEGORY:",":Y.AC.CURRENCY:",":Y.ACC.ID:",":Y.ACCOUNT.NAME:",":Y.CUSTOMER:",":Y.TRANS.AMOUNT:",":Y.TRANS.REF:",":Y.INPUTTER:",":Y.AUTHORISER
    CALL F.WRITE(FN.REDO.APAP.BKP.REP55,Y.STMT.ID,R.FINAL.VAL)
*
RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------------
END
