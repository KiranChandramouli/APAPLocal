$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>445</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE APAP.GET.SAV.ACCT.FILTER(ID.LIST)
*-----------------------------------------------------------------------------
* Description:
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_EB.MOB.FRMWRK.COMMON
*-----------------------------------------------------------------------------

*DEBUG

    GOSUB INITIALISE

    GOSUB PROCESS

    ID.LIST = SAV.ACCT.LIST
*    ID.LIST<-1> = "1014441390"
RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*----------

    SAV.ACCT.LIST = ''
*    ACCT.LIST = ID.LIST
    ACCT.LIST = ''
    CUSTOMER.NO = R.EB.EXTERNAL.USER<EB.XU.CUSTOMER>

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
    F.ACCOUNT.CLASS = ''
    CALL OPF(FN.ACCOUNT.CLASS, F.ACCOUNT.CLASS)


    ACCT.CLASS.ID = 'SAVINGS'
    E.ACCT.CLASS = ''
    CALL F.READ(FN.ACCOUNT.CLASS, ACCT.CLASS.ID, R.ACCT.CLASS, F.ACCOUNT.CLASS, E.ACCT.CLASS)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF = ''


    CALL OPF(FN.JOINT.CONTRACTS.XREF, F.JOINT.CONTRACTS.XREF)


*    PRINT '----------- ': CUSTOMER.NO : '-----'

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    IF NOT(ID.LIST) THEN
        CUST.NO = CUSTOMER.NO
        GOSUB GET.CUSTOMER.ACCOUNT
        ACCT.LIST<-1> = R.CUST.ACCT
        GOSUB GET.JOINT.CONTRACTS.XREF
        ACCT.LIST<-1> = R.JOINT.CONTRACTS.XREF
    END

    CALL F.READ(FN.CUSTOMER, CUSTOMER.NO, R.CUSTOMER, F.CUSTOMER, E.CUS)

    IF NOT(E.CUS) THEN
        SAVE.CUSTOMER.NO = CUSTOMER.NO
        CUS.REL.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE>
        CUS.REL.CUS = R.CUSTOMER<EB.CUS.REL.CUSTOMER>
        REL.CUS.CNT = DCOUNT(CUS.REL.CODE, @VM)
        FOR CUS.CNT = 1 TO REL.CUS.CNT
            IF CUS.REL.CODE<1, CUS.CNT> EQ 17 THEN
                CUST.NO = CUS.REL.CUS<1, CUS.CNT>
                GOSUB GET.CUSTOMER.ACCOUNT
                ACCT.LIST<-1> = R.CUST.ACCT
            END
        NEXT I
    END

RETURN

*-----------------------------------------------------------------------------
GET.CUSTOMER.ACCOUNT:
*--------------------

    R.CUST.ACCT = ''
    E.CUS.ACC = ''

    CALL F.READ(FN.CUSTOMER.ACCOUNT, CUST.NO, R.CUST.ACCT, F.CUSTOMER.ACCOUNT, E.CUS.ACC)

RETURN

*-----------------------------------------------------------------------------
GET.JOINT.CONTRACTS.XREF:
*--------------------

    R.JOINT.CONTRACTS.XREF = ''
    E.JOINT.CONTRACTS.XREF = ''

    CALL F.READ(FN.JOINT.CONTRACTS.XREF, CUST.NO, R.JOINT.CONTRACTS.XREF, F.JOINT.CONTRACTS.XREF, E.JOINT.CONTRACTS.XREF)

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
*            CALL F.READ(FN.ACCOUNT, ACCT.ID, R.ACCOUNT, F.ACCOUNT, E.ACC)
            READ R.ACCOUNT FROM F.ACCOUNT, ACCT.ID ELSE E.ACC = 'RECORD NOT FOUND'
            IF NOT(E.ACC)  THEN
                IF  R.ACCOUNT<AC.CUSTOMER> EQ CUSTOMER.NO  THEN
                    GOSUB CHECK.SAVING.ACCT
                END
                ELSE
                    Y.HOLDER.LIST = R.ACCOUNT<AC.JOINT.HOLDER>
                    Y.RELATION = R.ACCOUNT<AC.RELATION.CODE>
                    CONVERT @VM TO @FM IN Y.HOLDER.LIST
                    CONVERT @VM TO @FM IN Y.RELATION

                    LOCATE CUSTOMER.NO  IN Y.HOLDER.LIST SETTING Y.POS.HOLDER ELSE Y.POS.HOLDER = -1
                    Y.RELATION = Y.RELATION<Y.POS.HOLDER>
                    IF Y.POS.HOLDER NE -1 AND Y.RELATION MATCHES "500":@VM:"501":@VM:"510":@VM:"601":@VM:"601"   THEN
                        GOSUB CHECK.SAVING.ACCT
                    END
                END
            END
        END
    NEXT I

RETURN

*-----------------------------------------------------------------------------
CHECK.SAVING.ACCT:
*-----------------

    LOCATE R.ACCOUNT<AC.CATEGORY> IN R.ACCT.CLASS<AC.CLS.CATEGORY, 1> SETTING POS THEN
*    IF R.ACCOUNT<AC.CATEGORY> GE 6001 AND R.ACCOUNT<AC.CATEGORY> LE 6599 THEN
        LOCATE ACCT.ID IN SAV.ACCT.LIST SETTING Y.POS.ACC ELSE Y.POS.ACC = -1
        IF Y.POS.ACC EQ -1 THEN ;*AND R.ACCOUNT<AC.LOCAL.REF,18> NE "ABANDONED" THEN
            SAV.ACCT.LIST<-1> = ACCT.ID
        END
    END

RETURN

*-----------------------------------------------------------------------------

END
