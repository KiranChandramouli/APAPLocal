SUBROUTINE E.CONV.ADD.MEMBER
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.MB.SDB.CHARGES
    $INSERT I_F.MB.SDB.POST
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
PROCESS:

    Y.CHARGES.ID = O.DATA
    O.DATA = ''
    CALL F.READ(FN.MB.SDB.CHARGES,Y.CHARGES.ID,R.MB.SDB.CHARGES.REC,F.MB.SDB.CHARGES,CHARGES.ERR)
    Y.TRANSACTION.REF = R.MB.SDB.CHARGES.REC<SDB.CHG.TXN.REF>

    Y.MB.SDB.POST.ID = FIELD(Y.TRANSACTION.REF,"-",1)

    CALL F.READ(FN.MB.SDB.POST,Y.MB.SDB.POST.ID,R.MB.SDB.POST.REC,F.MB.SDB.POST,SDB.POST.ERR)
    O.DATA = R.MB.SDB.POST.REC<SDB.POST.ADD.ACCESS.CUST>

RETURN
*-----------------------------------------------------------------------------
*/////////////////////////////////////////////////////////////////////////////
*////////////////P R E  P R O C E S S  S U B R O U T I N E S /////////////////
*/////////////////////////////////////////////////////////////////////////////
*-----------------------------------------------------------------------------
INITIALISE:

    R.MB.SDB.CHARGES.REC=''
    Y.TRANSACTION.REF=''
    Y.MB.SDB.POST.ID=''
    R.MB.SDB.POST.REC=''

RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:

    FN.MB.SDB.POST = 'F.MB.SDB.POST'
    F.MB.SDB.POST = ''

    FN.MB.SDB.CHARGES = 'F.MB.SDB.CHARGES'
    F.MB.SDB.CHARGES = ''

    CALL OPF(FN.MB.SDB.POST,F.MB.SDB.POST)
    CALL OPF(FN.MB.SDB.CHARGES,F.MB.SDB.CHARGES)

RETURN
*-----------------------------------------------------------------------------
END
