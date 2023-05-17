*-----------------------------------------------------------------------------
* <Rating>-53</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE E.BEA.SDB.DAILY.STAT.RTN(Y.PROCESSED.ARR)
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.MB.SDB.POST
    $INSERT I_F.MB.SDB.STATUS
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
PROCESS:

    SEL.CMD = 'SELECT ':FN.MB.SDB.TYPE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.RECS,SEL.ERR)
    LOOP
        REMOVE BOX.ID FROM SEL.LIST SETTING POS.BOX.ID
    WHILE BOX.ID:POS.BOX.ID
        GOSUB RENTED.PROCESS
    REPEAT

    RETURN
*-----------------------------------------------------------------------------
RENTED.PROCESS:

    SEL.SDB.STAT.CMD = 'SELECT ':FN.MB.SDB.STATUS:' WITH @ID LIKE ...':BOX.ID:'...'
    CALL EB.READLIST(SEL.SDB.STAT.CMD,SDB.STAT.LIST,'',NO.BOX.REC,BOX.ERR)
    BOX.RENTED.CUSTOMERS = 0
    BOX.RENTED.STAFF = 0
    LOOP
        REMOVE SDB.STAT.ID FROM SDB.STAT.LIST SETTING POS.STAT.ID

    WHILE SDB.STAT.ID:POS.STAT.ID
        CALL F.READ(FN.MB.SDB.STATUS,SDB.STAT.ID,R.MB.SDB.STATUS.REC,F.MB.SDB.STATUS,SDB.STATUS.ERR)
        CUSTOMER.ID = R.MB.SDB.STATUS.REC<SDB.STA.CUSTOMER.NO>

        CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER.REC,F.CUSTOMER,CUST.ERR)
        CUSTOMER.INDUSTRY = R.CUSTOMER.REC<EB.CUS.INDUSTRY>

        IF CUSTOMER.INDUSTRY NE '1040' THEN
            BOX.RENTED.CUSTOMERS = BOX.RENTED.CUSTOMERS + 1
        END
        ELSE
            BOX.RENTED.STAFF = BOX.RENTED.STAFF + 1
        END
        Y.PROCESSED.ARR<-1>=BOX.RENTED.CUSTOMERS:"*":BOX.RENTED.STAFF
    REPEAT

    RETURN
*-----------------------------------------------------------------------------
*/////////////////////////////////////////////////////////////////////////////
*////////////////P R E  P R O C E S S  S U B R O U T I N E S /////////////////
*/////////////////////////////////////////////////////////////////////////////
*-----------------------------------------------------------------------------
INITIALISE:

    Y.PROCESSED.ARR=''
    SEL.CMD=''
    SEL.LIST=''
    NO.RECS=''
    SEL.ERR=''
    BOX.ID=''
    POS.BOX.ID=''
    SEL.SDB.STAT.CMD=''
    SDB.STAT.LIST=''
    NO.BOX.REC=''
    SDB.STAT.ID=''
    POS.STAT.ID=''
    R.MB.SDB.STATUS.REC=''
    CUSTOMER.ID=''
    R.CUSTOMER.REC=''
    CUSTOMER.INDUSTRY=''
    BOX.RENTED.CUSTOMERS=''
    BOX.RENTED.STAFF=''

    RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:

    FN.MB.SDB.TYPE = 'F.MB.SDB.TYPE'
    F.MB.SDB.TYPE = ''
    CALL OPF(FN.MB.SDB.TYPE,F.MB.SDB.TYPE)

    FN.MB.SDB.POST = 'F.MB.SDB.POST'
    F.MB.SDB.POST  = ''
    CALL OPF(FN.MB.SDB.POST,F.MB.SDB.POST)

    FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'
    F.MB.SDB.STATUS = ''
    CALL OPF(FN.MB.SDB.STATUS,F.MB.SDB.STATUS)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    RETURN
*-----------------------------------------------------------------------------
END


