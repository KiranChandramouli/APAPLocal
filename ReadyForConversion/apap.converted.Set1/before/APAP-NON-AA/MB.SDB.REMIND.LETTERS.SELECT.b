*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.SDB.REMIND.LETTERS.SELECT


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.USER
    $INSERT I_F.DATES
    $INSERT I_F.MB.SDB.STATUS
    $INSERT I_F.MB.SDB.PARAM
    $INSERT I_MB.SDB.REMIND.LETTERS.COMMON


    Y.LIST = ''
    IF REMINDER.NOTICE.FREQ AND SDB.MAP.KEY THEN
        Y.COUNT = ''; Y.ERR = ''
        Y.SELECT = "SELECT ":FN.MB.SDB.STATUS:" WITH REMINDER.DUE.ON NE '' AND REMINDER.DUE.ON GE ":START.PERIOD:" AND REMINDER.DUE.ON LT ":END.PERIOD:" BY @ID"
        CALL EB.READLIST(Y.SELECT, Y.LIST, '', Y.COUNT, Y.ERR)
    END

    CALL BATCH.BUILD.LIST('', Y.LIST)

    RETURN

END



