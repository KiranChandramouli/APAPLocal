* @ValidationCode : MjotODIxMzI5MTgyOkNwMTI1MjoxNjk4NDA1NTM4MTgxOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:48:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE APAP.GET.DEP.ACCT.FILTER(ID.LIST)
*-----------------------------------------------------------------------------
* Description:
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_EB.MOB.FRMWRK.COMMON
*-----------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB PROCESS

    ID.LIST = DEP.ACCT.LIST

RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*----------

    DEP.ACCT.LIST = ''
    ACCT.LIST = ID.LIST
    CUSTOMER.NO = R.EB.EXTERNAL.USER<EB.XU.CUSTOMER>

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.AZ.PROD.PARAM = 'F.AZ.PRODUCT.PARAMETER'
    F.AZ.PROD.PARAM = ''
    CALL OPF(FN.AZ.PROD.PARAM, F.AZ.PROD.PARAM)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT, F.AZ.ACCOUNT)

    FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF = ''
    CALL OPF(FN.JOINT.CONTRACTS.XREF, F.JOINT.CONTRACTS.XREF)

    IF NOT(ID.LIST) THEN
        FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
        F.CUSTOMER.ACCOUNT = ''
        CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
        CUST.NO = CUSTOMER.NO
        GOSUB GET.CUSTOMER.ACCOUNT
        ACCT.LIST<-1> = R.CUST.ACCT
        GOSUB GET.JOINT.CONTRACTS.XREF
        ACCT.LIST<-1> = R.JOINT.CONTRACTS.XREF
    END

* CALL F.READ(FN.CUSTOMER, CUSTOMER.NO, R.CUSTOMER, F.CUSTOMER, E.CUS)
*
* IF NOT(E.CUS) THEN
*  CUSTOMER.LIST = R.CUSTOMER<EB.USE.REL.CUSTOMER>
*  CUST.CNT = DCOUNT(CUSTOMER.LIST, FM)
*  FOR I=1 TO CUST.CNT
*   CUST.NO = CUSTOMER.LIST<I>
*   GOSUB GET.CUSTOMER.ACCOUNT
*   ACCT.LIST<-1> = R.CUST.ACCT
*  NEXT I
* END

RETURN

*-----------------------------------------------------------------------------
GET.CUSTOMER.ACCOUNT:
*--------------------

    R.CUST.ACCT = ''
    E.CUS.ACC = ''

    CALL F.READ(FN.CUSTOMER.ACCOUNT, CUST.NO, R.CUST.ACCT, F.CUSTOMER.ACCOUNT, E.CUS.ACC)

RETURN
*-------------------------------------------------------------------------
GET.JOINT.CONTRACTS.XREF:
*--------------------

    R.JOINT.CONTRACTS.XREF = ''
    E.JOINT.CONTRACTS.XREF = ''

    CALL F.READ(FN.JOINT.CONTRACTS.XREF, CUST.NO, R.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF, E.JOINT.CONTRACTS.XREF)

RETURN


*-----------------------------------------------------------------------------
PROCESS:
*-------

    ACCT.CNT = DCOUNT(ACCT.LIST, @FM)

    FOR I=1 TO ACCT.CNT
        ACCT.ID = ACCT.LIST<I>
        E.ACC = ''
        R.ACCOUNT = ''
        IF ACCT.ID THEN
* CALL F.READ(FN.ACCOUNT, ACCT.ID, R.ACCOUNT, F.ACCOUNT, E.ACC)
            READ R.ACCOUNT FROM F.ACCOUNT, ACCT.ID ELSE E.ACC = 'RECORD NOT FOUND'
            IF NOT(E.ACC) THEN
                E.AZ.ACC = ''
                R.AZ.ACCOUNT = ''
                CALL F.READ(FN.AZ.ACCOUNT, ACCT.ID, R.AZ.ACCOUNT, F.AZ.ACCOUNT, E.AZ.ACC)
                IF NOT(E.AZ.ACC) THEN
                    GOSUB CHECK.DEPOSIT.ACCT
                END
            END
        END
    NEXT I

RETURN

*-----------------------------------------------------------------------------
CHECK.DEPOSIT.ACCT:
*------------------

*    IF R.ACCOUNT<AC.CATEGORY> GE 6600 AND R.ACCOUNT<AC.CATEGORY> LE 6619 THEN
    READ R.AZ.PROD.PARAM FROM F.AZ.PROD.PARAM, R.ACCOUNT<AC.CATEGORY> THEN
        LOCATE ACCT.ID IN DEP.ACCT.LIST SETTING Y.POS.ACC ELSE Y.POS.ACC =-1
        IF Y.POS.ACC EQ -1 THEN
            DEP.ACCT.LIST<-1> = ACCT.ID
        END
    END

RETURN

*-----------------------------------------------------------------------------

END
