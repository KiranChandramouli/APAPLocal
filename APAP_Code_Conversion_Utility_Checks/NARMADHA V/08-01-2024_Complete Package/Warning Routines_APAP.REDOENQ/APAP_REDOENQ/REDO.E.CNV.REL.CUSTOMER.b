* @ValidationCode : MjotMTk1NTkyMzgyMDpVVEYtODoxNzAzNTk1NDg5NTQzOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Dec 2023 18:28:09
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
SUBROUTINE REDO.E.CNV.REL.CUSTOMER
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 26-12-2023         Narmadha V            Manaul R22 Conversion   Call Rouitne Format Modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.RELATION
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.RELATION.CUSTOMER
    $USING EB.LocalReferences

    GOSUB INITIALIZE
    GOSUB FIELD.CHECK

RETURN

INITIALIZE:
*------------------------------------------------------------
* The variables are initialized here
*------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)

RETURN

FIELD.CHECK:
*------------------------------------------------------------
* The local field L.CU.TIPO.CL value is checked here and based on the result,
* the values are concatenated
*------------------------------------------------------------
    REF.POS = ''
* CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',REF.POS)
    EB.LocalReferences.GetLocRef('CUSTOMER','L.CU.TIPO.CL',REF.POS) ;*Manual R22 Conversion - Call Rouitne Format Modified
    Y.ID = O.DATA
    CUSTOMER.ID = FIELD(Y.ID,"-",1)
    ACCOUNT.ID = FIELD(Y.ID,"-",2)
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,F.ERR)

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "CLIENTE MENOR" THEN
        Y.NAME1 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END ELSE
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA JURIDICA" THEN
            Y.NAME1 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
    END
    GOSUB GET.RELATION

    IF Y.FINAL.VAL THEN
        Y.FINAL.VAL = CHANGE(Y.FINAL.VAL,@FM,'')
        O.DATA = Y.NAME1: ' ' :Y.FINAL.VAL
    END ELSE
        O.DATA = Y.NAME1
    END

RETURN
*------------------
GET.RELATION:
*------------------

    Y.ACC.REL.CODE = R.ACCOUNT<AC.RELATION.CODE>
    Y.ACC.REL.CODE = CHANGE(Y.ACC.REL.CODE,@VM,@FM)
    Y.CNT = DCOUNT(Y.ACC.REL.CODE,@FM)
    LOOP.CNTR = 1
    LOOP
    WHILE LOOP.CNTR LE Y.CNT
        Y.VAR = Y.ACC.REL.CODE<LOOP.CNTR>
        IF Y.VAR GE 500 AND Y.VAR LE 529 THEN

            CALL F.READ(FN.RELATION,Y.VAR,R.RELATION,F.RELATION,REL.ERR)
            Y.ACC.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
            Y.ACC.JOINT.HOLD = R.ACCOUNT<AC.JOINT.HOLDER,LOOP.CNTR>

            CALL F.READ(FN.CUSTOMER,Y.ACC.JOINT.HOLD,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

            IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "CLIENTE MENOR" THEN
                Y.NAME2 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
            END ELSE
                IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA JURIDICA" THEN
                    Y.NAME2 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
                END
            END
            Y.NAME3 = Y.NAME2
            Y.NAME2 = ''

            Y.FINAL.VAL<-1> = Y.ACC.REL.DESC: ' ' :Y.NAME3:' '
        END
        LOOP.CNTR + =1
    REPEAT

RETURN
*----------------------
END
