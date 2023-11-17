* @ValidationCode : MjoxODIxMTQ4MzM0OkNwMTI1MjoxNjk4NDA1NTM4MjI4OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
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
SUBROUTINE APAP.GET.LOAN.ACCT.FILTER(ID.LIST)
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
*   $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT
*-----------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB PROCESS

    ID.LIST = LOAN.ACCT.LIST

RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*----------

    LOAN.ACCT.LIST = ''
    ACCT.LIST = ID.LIST
    CUSTOMER.NO = R.EB.EXTERNAL.USER<EB.XU.CUSTOMER>

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    
    FN.REDO.CUSTOMER.ARRANGEMENT = 'F.REDO.CUSTOMER.ARRANGEMENT'
    F.REDO.CUSTOMER.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    IF NOT(ID.LIST) THEN
        FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
        F.CUSTOMER.ACCOUNT = ''
        CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
        CUST.NO = CUSTOMER.NO
        GOSUB GET.CUSTOMER.ACCOUNT
        ACCT.LIST<-1> = R.CUST.ACCT
        GOSUB GET.ARR.ACCOUNT
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
GET.ARR.ACCOUNT:
*--------------------
    R.AAR.ACCT = ''
    E.ARR.ACC = ''

    CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT, CUST.NO, R.REDO.CUSTOMER.ARRANGEMENT, F.REDO.CUSTOMER.ARRANGEMENT ,E.ARR.ACC)
    
    Y.LIST.ARR = R.REDO.CUSTOMER.ARRANGEMENT<2>
    CONVERT @VM TO @FM IN Y.LIST.ARR
    CONVERT @SM TO @FM IN Y.LIST.ARR
    
    ARR.CNT = DCOUNT(Y.LIST.ARR, @FM)

    FOR I=1 TO ARR.CNT
        Y.ID.ARR = Y.LIST.ARR<I>
        E.AA.ARRANGEMENT =""
        R.AA.ARRANGEMENT=""
        CALL F.READ(FN.AA.ARRANGEMENT , Y.ID.ARR , R.AA.ARRANGEMENT , F.AA.ARRANGEMENT , E.AA.ARRANGEMENT )
        IF R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL> = "ACCOUNT" THEN
            ACCT.LIST<-1> = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
        END
     
    NEXT I
    
    
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
            IF NOT(E.ACC) THEN
                GOSUB CHECK.LOAN.ACCT
            END
        END
    NEXT I

RETURN

*-----------------------------------------------------------------------------
CHECK.LOAN.ACCT:
*-----------------

    IF R.ACCOUNT<AC.ARRANGEMENT.ID> NE "" AND R.ACCOUNT<AC.CATEGORY> NE 3173 AND  R.ACCOUNT<AC.CATEGORY> NE 3174 THEN
        LOAN.ACCT.LIST<-1> = ACCT.ID
    END

RETURN
*-----------------------------------------------------------------------------

END
