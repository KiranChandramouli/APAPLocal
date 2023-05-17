SUBROUTINE REDO.B.CUSTOMER.PROVISION.LOAD
******************************************************************************
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : G.Bharath
*  ODR Number        : ODR-2009-11-0159
*  Program   Name    : REDO.B.CUSTOMER.PROVISION.LOAD
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* DESCRIPTION       : This Multi-thread BATCH routine is to calculate CUSTOMER provision
*                     values based on the arrangements with the CUSTOMER during COB
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO            REFERENCE            DESCRIPTION
*  -----           ----           ----------           -----------
*  22-Oct-2010     G.Bharath      ODR-2009-11-0159     INITIAL CREATION
*  14-May-2011     Sudharsanan S  PACS00061656         Parameter table - @ID changed to "SYSTEM"
* 07-JULY-2011     JEEVA T      PACS00064596          changes in claculating overdue days
*-------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
    $INSERT I_REDO.B.CUSTOMER.PROVISION.COMMON
*****************************************************************************
*
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*****************************************************************************
OPEN.FILES:
*----------------------------------------------------------------------------
*

    FN.CUSTOMER = 'F.CUSTOMER'
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    R.AA.ACCOUNT.DETAILS = ''
    F.CUSTOMER.ACCOUNT  = ''
    F.CUSTOMER  = ''
    R.CUSTOMER  = ''
    R.CUSTOMER.ACCOUNT  = ''
    FN.REDO.CUSTOMER.ARRANGEMENT = 'F.REDO.CUSTOMER.ARRANGEMENT'
    F.REDO.CUSTOMER.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    R.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'
    F.AA.ARR.TERM.AMOUNT  = ''
    R.AA.ARR.TERM.AMOUNT  = ''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL  = ''
    R.COLLATERAL  = ''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY  = ''
    R.AA.ACTIVITY.HISTORY  = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.REDO.H.PROVISION.PARAMETER = 'F.REDO.H.PROVISION.PARAMETER'
    F.REDO.H.PROVISION.PARAMETER  = ''
    R.REDO.H.PROVISION.PARAMETER  = ''
    CALL OPF(FN.REDO.H.PROVISION.PARAMETER,F.REDO.H.PROVISION.PARAMETER)

    FN.REDO.H.CUSTOMER.PROVISIONING = 'F.REDO.H.CUSTOMER.PROVISIONING'
    F.REDO.H.CUSTOMER.PROVISIONING  = ''
    R.REDO.H.CUSTOMER.PROVISIONING  = ''
    CALL OPF(FN.REDO.H.CUSTOMER.PROVISIONING,F.REDO.H.CUSTOMER.PROVISIONING)

    FN.REDO.H.CUSTOMER.PROVISIONING.HIS = 'F.REDO.H.CUSTOMER.PROVISIONING$HIS'
    F.REDO.H.CUSTOMER.PROVISIONING.HIS  = ''
    R.REDO.H.CUSTOMER.PROVISIONING.HIS  = ''
    CALL OPF(FN.REDO.H.CUSTOMER.PROVISIONING.HIS,F.REDO.H.CUSTOMER.PROVISIONING.HIS)

    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT  = ''
    R.ALTERNATE.ACCOUNT  = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS  = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.REDO.AA.LOAN.UPD.STATUS = 'F.REDO.AA.LOAN.UPD.STATUS'
    F.REDO.AA.LOAN.UPD.STATUS  = ''
    CALL OPF(FN.REDO.AA.LOAN.UPD.STATUS,F.REDO.AA.LOAN.UPD.STATUS)

    Y.LOAN.COND.POS     = ''
    Y.STATUS.CHG.DT.POS = ''
    Y.LOAN.STATUS.1.POS = ''

RETURN
*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------
*
*PACS00061656 - S
    VAR.PARAM.ID = "SYSTEM"
    CALL CACHE.READ(FN.REDO.H.PROVISION.PARAMETER,VAR.PARAM.ID,R.REDO.H.PROVISION.PARAMETER,PROV.ERR)
*PACS00061656 - E
    Y.NEXT.RUN.DATE = R.REDO.H.PROVISION.PARAMETER<PROV.NEXT.RUN.DATE>


    CLASS.ARRAY.POS = "F":@FM:"E":@FM:"D":@FM:"C":@FM:"B":@FM:"A"

*-----------------------
* Get Local.Ref Position
*-----------------------

    APPLNS = "AA.PRD.DES.OVERDUE":@FM:"AA.PRD.DES.TERM.AMOUNT":@FM:"AA.PRD.DES.ACCOUNT"
    FIELD.NAMES = "L.LOAN.COND":@VM:"L.STATUS.CHG.DT":@VM:"L.LOAN.STATUS.1":@FM:"L.AA.COL":@FM:"L.PROV.RESTRUCT"
    FIELD.POS = ''

    CALL MULTI.GET.LOC.REF(APPLNS,FIELD.NAMES,FIELD.POS)
    Y.LOAN.COND.POS     =  FIELD.POS<1,1>
    Y.STATUS.CHG.DT.POS =  FIELD.POS<1,2>
    Y.LOAN.STATUS.1.POS =  FIELD.POS<1,3>
    Y.AA.COL.POS        =  FIELD.POS<2,1>
    Y.PROV.RESTRUCT.POS =  FIELD.POS<3,1>

RETURN
*-------------------------------------------------------------------------------
END
