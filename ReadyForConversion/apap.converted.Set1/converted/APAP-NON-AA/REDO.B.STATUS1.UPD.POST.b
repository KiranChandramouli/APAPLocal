SUBROUTINE REDO.B.STATUS1.UPD.POST
*-----------------------------------------------------------------------------------------
* Job routine to merge data from REDO.CUST.PRD.LST to REDO.CUST.PRD.LIST
*
*-----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.CUST.PRD.LIST

    GOSUB Initialise
    GOSUB SelectRec
    GOSUB UpdatePrdList
    GOSUB ClearRec

RETURN

Initialise:
*----------

    FN.CUST.PRD.LIST='F.REDO.CUST.PRD.LIST'
    F.CUST.PRD.LIST=''
    CALL OPF(FN.CUST.PRD.LIST,F.CUST.PRD.LIST)

    FN.CUST.PRD.LST='F.REDO.CUST.PRD.LST'
    F.CUST.PRD.LST=''
    CALL OPF(FN.CUST.PRD.LST, F.CUST.PRD.LST)

    Y.LAST.WRK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    CheckDate = Y.LAST.WRK.DAY:'*'
    SelCmd = ''
    SelList = ''
    RecordSelected = 0
    R.CUST.PRD.LIST = ''
    TtlAcs = 0

RETURN
*---------(Initialise)


SelectRec:
*---------

* SELECT REDO.CUST.PRD.LST
    SelCmd = 'SELECT ' : FN.CUST.PRD.LST : ' BY @ID'
    CALL EB.READLIST(SelCmd, SelList, '', RecordSelected, '')

RETURN
*---------(SelectRec)

UpdatePrdList:
*-------------

    PrevCust = ''
    IF RecordSelected THEN

        LOOP
        UNTIL SelList<1> = ''

            RecID = SelList<1>
            DEL SelList<1>

            CustID = FIELD(RecID,'-',1)

            IF PrevCust EQ '' THEN
                PrevCust = CustID
            END

            IF CustID NE PrevCust THEN
                CALL F.WRITE(FN.CUST.PRD.LIST, PrevCust, R.CUST.PRD.LIST)
                R.CUST.PRD.LIST = ''
                PrevCust = CustID
            END

            R.CUST.PRD.LST = ''
            Err = ''
            CALL F.READ(FN.CUST.PRD.LST, RecID, R.CUST.PRD.LST, F.CUST.PRD.LST, Err)

            IF R.CUST.PRD.LIST EQ '' THEN      ;* do not read multiple times
                CALL F.READ(FN.CUST.PRD.LIST, CustID, R.CUST.PRD.LIST, F.CUST.PRD.LIST, Err)
                TtlAcs = DCOUNT(R.CUST.PRD.LIST<PRD.PRODUCT.ID>, @VM)
            END

            FOR xCtr = 1 TO TtlAcs
                IF R.CUST.PRD.LST<PRD.DATE,xCtr> EQ  CheckDate THEN  ;* check the date with a *
                    R.CUST.PRD.LIST<PRD.DATE,xCtr> = Y.LAST.WRK.DAY   ;* update correct date
                    R.CUST.PRD.LIST<PRD.PROCESS.DATE> = Y.LAST.WRK.DAY
                    R.CUST.PRD.LIST<PRD.PRD.STATUS,xCtr> = R.CUST.PRD.LST<PRD.PRD.STATUS,xCtr>      ;* update status
                    R.CUST.PRD.LIST<PRD.TYPE.OF.CUST,xCtr> = R.CUST.PRD.LST<PRD.TYPE.OF.CUST,xCtr>
                END
            NEXT xCtr
        REPEAT

        CALL F.WRITE(FN.CUST.PRD.LIST, PrevCust, R.CUST.PRD.LIST)

    END

RETURN
*---------(UpdatePrdList)


ClearRec:
*--------

    IF RecordSelected THEN
* clear REDO.CUST.PRD.LST
        CALL EB.CLEAR.FILE(FN.CUST.PRD.LST, F.CUST.PRD.LST)
    END

RETURN
*---------(ClearRec)

END
