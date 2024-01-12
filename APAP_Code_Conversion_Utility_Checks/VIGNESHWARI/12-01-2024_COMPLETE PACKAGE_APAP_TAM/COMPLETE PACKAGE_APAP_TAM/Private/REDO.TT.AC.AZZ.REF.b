* @ValidationCode : MjotODQ2NjA0MzYxOkNwMTI1MjoxNzA0OTcyNDM3ODk2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Jan 2024 16:57:17
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
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM, FM TO @FM
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     F.READ TO CACHE.READ
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.TT.AC.AZZ.REF(Y.FIELD.NAME)
*-------------------------------------------------------------
*Description: This routine is call routine from deal slip of TT

*-------------------------------------------------------------
*Input Arg : Y.INP.DEAL
*Out Arg : Y.INP.DEAL
*Deals With: TT payement
*-------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.RELATION
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CATEGORY
    $USING EB.LocalReferences
 
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------------------------------------

    BEGIN CASE




        CASE Y.FIELD.NAME EQ 'Y.ACCT.CATEGORY'
            GET.ACCT.TITLE = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.AZ.ACC.REF>
            GOSUB GET.ACCT.DETAILS

            RETURN

        CASE Y.FIELD.NAME EQ 'Y.ACCT.REGULARORY'
            GET.ACCT.TITLE = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.AZ.ACC.REF>
            GOSUB GET.ACCT.REGULATORY

            RETURN

        CASE Y.FIELD.NAME EQ 'Y.NAME'
            GET.ACCT.TITLE = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.AZ.ACC.REF>
            GOSUB B78.GET.CUS.NAME
            RETURN


    END CASE


RETURN





*----------------------------------------------------------------------------------------------------------------------
GET.ACCT.DETAILS:
*----------------------------------------------------------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    CALL F.READ(FN.ACCOUNT,GET.ACCT.TITLE,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    IF ACCOUNT.ERR NE '' THEN
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,GET.ACCT.TITLE,R.ACCOUNT,ACC.ERR)
    END

    Y.ACCT.CATEG = R.ACCOUNT<AC.CATEGORY>
    CALL CACHE.READ(FN.CATEGORY, Y.ACCT.CATEG, R.CATEGORY, CATEGORY.ERR) ;*R22 AUTO CONVERSION
    Y.ACCT.CATEG = R.CATEGORY<EB.CAT.DESCRIPTION>
    Y.ACCT.CATEG = Y.ACCT.CATEG[1,30]
    Y.FIELD.NAME = FMT(Y.ACCT.CATEG,"30R")

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.ACCT.REGULATORY:
*----------------------------------------------------------------------------------------------------------------------


    LOC.REF.FIELD = 'L.AC.ALPH.AC.NO'
    LOC.REF.APP = 'ACCOUNT'
    LOC.POS = ''
*    CALL GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)
    EB.LocalReferences.GetLocRef(LOC.REF.APP,LOC.REF.FIELD,LOC.POS);* R22 UTILITY AUTO CONVERSION


    VAR.RCEP.MTHD = R.NEW(TT.TE.LOCAL.REF)<1,LOC.POS>

    CALL F.READ(FN.ACCOUNT,GET.ACCT.TITLE,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    IF ACCOUNT.ERR NE '' THEN
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,GET.ACCT.TITLE,R.ACCOUNT,ACC.ERR)
    END

    Y.ACCT.REF= R.ACCOUNT<AC.LOCAL.REF,LOC.POS>
    Y.FIELD.NAME = FMT(Y.ACCT.REF,"30R")

RETURN

*----------------------------------------------------------------------------------------------------------------------
B78.GET.CUS.NAME:
*----------------------------------------------------------------------------------------------------------------------



    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)

    CALL F.READ(FN.ACCOUNT,GET.ACCT.TITLE,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    IF ACCOUNT.ERR NE '' THEN
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,GET.ACCT.TITLE,R.ACCOUNT,ACC.ERR)
    END

    CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "CLIENTE MENOR" THEN
        Y.NAME1 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END ELSE
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "PERSONA JURIDICA" THEN
            Y.NAME1 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
    END
    GOSUB JOINT.HOLDER.CHECK
    Y.NAME = Y.NAME1:' ':Y.REL.DESC:' ':Y.NAME2
    Y.FIELD.NAME = FMT(Y.NAME,"36R")
RETURN
*----------------------------------------------------------------------------------------------------------------------
JOINT.HOLDER.CHECK:
*----------------------------------------------------------------------------------------------------------------------

    Y.RELATION.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE>
    IF Y.RELATION.CODE GE 500 AND Y.RELATION.CODE LE 529 THEN
        CALL F.READ(FN.RELATION,Y.RELATION.CODE,R.RELATION,F.RELATION,REL.ERR)
        Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
        Y.ACC.JOINT.HOLD = R.ACCOUNT<AC.JOINT.HOLDER>
        CALL F.READ(FN.CUSTOMER,Y.ACC.JOINT.HOLD,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
        Y.NAME = R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS>
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "CLIENTE MENOR" THEN
            Y.NAME2 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
        END ELSE
            IF R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "PERSONA JURIDICA" THEN
                Y.NAME2 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
            END
        END
    END
RETURN
*----------------------------------------------------------------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HIS = ''
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)


    Y.APPL = 'CUSTOMER':@FM:'TELLER' ;*R22 AUTO CONVERSION
    Y.FIELD = 'L.CU.TIPO.CL':@FM:'L.TT.AZ.ACC.REF':@VM:'L.TT.COMM.AMT' ;*R22 AUTO CONVERSION
    Y.FLD.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FIELD,Y.FLD.POS)
    GET.REF.POS = Y.FLD.POS<1,1>
    L.TT.AZ.ACC.REF = Y.FLD.POS<2,1>
    L.TT.COMM.AMT.POS = Y.FLD.POS<2,2>

    GET.ACCT.TITLE = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.AZ.ACC.REF>



RETURN

END
