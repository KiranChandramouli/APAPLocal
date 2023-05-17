SUBROUTINE REDO.FOREX.SEQ.NUM.VALIDATE

*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.FOREX.SEQ.NUM table fields
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Chandra Prakash T
* PROGRAM NAME : REDO.FOREX.SEQ.NUM.VALIDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference         Description
* 04-May-2010      Chandra Prakash T  ODR-2010-01-0213  Initial creation
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FOREX
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.FOREX.SEQ.NUM

    GOSUB INITIALISATION
    GOSUB PROCESS

RETURN

*------------------------------------------------------------------------------------------------------
INITIALISATION:
*------------------------------------------------------------------------------------------------------

    FN.REDO.FOREX.SEQ.NUM = 'F.REDO.FOREX.SEQ.NUM'
    F.REDO.FOREX.SEQ.NUM = ''
    CALL OPF(FN.REDO.FOREX.SEQ.NUM,F.REDO.FOREX.SEQ.NUM)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FOREX = 'F.FOREX'
    F.FOREX = ''
    CALL OPF(FN.FOREX,F.FOREX)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FUNDS.TRANSFER.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER.NAU = ''
    CALL OPF(FN.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU)

    FN.FOREX.NAU = 'F.FOREX$NAU'
    F.FOREX.NAU = ''
    CALL OPF(FN.FOREX.NAU,F.FOREX.NAU)

    FN.TELLER.NAU = 'F.TELLER$NAU'
    F.TELLER.NAU = ''
    CALL OPF(FN.TELLER.NAU,F.TELLER.NAU)

    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)

    FN.FOREX.HIS = 'F.FOREX$HIS'
    F.FOREX.HIS = ''
    CALL OPF(FN.FOREX.HIS,F.FOREX.HIS)

    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
    CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)

    R.TXN.RECORD.NAU = ''
    R.TXN.RECORD = ''
    R.TXN.RECORD.HIS = ''
RETURN

*------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------

    T24.TXN.REF = R.NEW(REDO.FXSN.FX.TXN.ID)
    TXN.APP.NAME = T24.TXN.REF[1,2]

    IF T24.TXN.REF EQ "" AND R.NEW(REDO.FXSN.FX.SEQ.STATUS) NE "AVAILABLE" THEN
        R.NEW(REDO.FXSN.FX.SEQ.STATUS) = "AVAILABLE"
    END ELSE
        IF APPLICATION EQ "REDO.FOREX.SEQ.NUM" THEN
            R.NEW(REDO.FXSN.MANUAL.UPDATE) = "YES"
        END

        GOSUB CHECK.T24.TXN.STATUS

        BEGIN CASE
            CASE R.TXN.RECORD.NAU NE ""
                GOSUB T24.TXN.REF.IN.NAU
            CASE (R.TXN.RECORD NE "" AND TXN.RECORD.STATUS EQ "")
* PACS00239739 - S
*            GOSUB T24.TXN.REF.IN.LIVE   ;* T24 Transaction in Live
* PACS00239739 - E
            CASE R.TXN.RECORD.HIS NE ""
                GOSUB T24.TXN.REF.IN.HIS
            CASE OTHERWISE
                ETEXT = "EB-FX.TXN.ID.NOT.FOUND"
                CALL STORE.END.ERROR
        END CASE

    END

RETURN

*------------------------------------------------------------------------------------------------------
CHECK.T24.TXN.STATUS:
*------------------------------------------------------------------------------------------------------

    BEGIN CASE
        CASE TXN.APP.NAME EQ 'FT'
            GOSUB CHECK.FT.TXN.STATUS
        CASE TXN.APP.NAME EQ 'FX'
            GOSUB CHECK.FX.TXN.STATUS
        CASE TXN.APP.NAME EQ 'TT'
            GOSUB CHECK.TT.TXN.STATUS
    END CASE

RETURN

*------------------------------------------------------------------------------------------------------
CHECK.FT.TXN.STATUS:
*------------------------------------------------------------------------------------------------------

    R.FUNDS.TRANSFER.NAU = ''
    FUNDS.TRANSFER.NAU.ERR = ''
    CALL F.READ(FN.FUNDS.TRANSFER.NAU,T24.TXN.REF,R.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU,FUNDS.TRANSFER.NAU.ERR)
    IF R.FUNDS.TRANSFER.NAU NE "" THEN
        R.TXN.RECORD.NAU = R.FUNDS.TRANSFER.NAU
        TXN.RECORD.STATUS = R.FUNDS.TRANSFER.NAU<FT.RECORD.STATUS>
    END ELSE
        R.FUNDS.TRANSFER = ''
        FUNDS.TRANSFER.ERR = ''
        CALL F.READ(FN.FUNDS.TRANSFER,T24.TXN.REF,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
        IF R.FUNDS.TRANSFER NE "" THEN
            R.TXN.RECORD = R.FUNDS.TRANSFER
            TXN.RECORD.STATUS = R.FUNDS.TRANSFER<FT.RECORD.STATUS>
        END ELSE
            HIS.FOUND.ERR = ''
            R.TXN.RECORD.HIS = ''
            CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,T24.TXN.REF,R.TXN.RECORD.HIS,HIS.FOUND.ERR)
            TXN.RECORD.STATUS = R.TXN.RECORD.HIS<FT.RECORD.STATUS>
        END
    END

RETURN

*------------------------------------------------------------------------------------------------------
CHECK.FX.TXN.STATUS:
*------------------------------------------------------------------------------------------------------

    R.FOREX.NAU = ''
    FOREX.NAU.ERR = ''
    CALL F.READ(FN.FOREX.NAU,T24.TXN.REF,R.FOREX.NAU,F.FOREX.NAU,FOREX.NAU.ERR)
    IF R.FOREX.NAU NE "" THEN
        R.TXN.RECORD.NAU = R.FOREX.NAU
        TXN.RECORD.STATUS = R.FOREX.NAU<FX.RECORD.STATUS>
    END ELSE
        R.FOREX = ''
        FOREX.ERR = ''
        CALL F.READ(FN.FOREX,T24.TXN.REF,R.FOREX,F.FOREX,FOREX.ERR)
        IF R.FOREX NE "" THEN
            R.TXN.RECORD = R.FOREX
            TXN.RECORD.STATUS = R.FOREX<FX.RECORD.STATUS>
        END ELSE
            HIS.FOUND.ERR = ''
            R.TXN.RECORD.HIS = ''
            CALL EB.READ.HISTORY.REC(F.FOREX.HIS,T24.TXN.REF,R.TXN.RECORD.HIS,HIS.FOUND.ERR)
            TXN.RECORD.STATUS = R.TXN.RECORD.HIS<FX.RECORD.STATUS>
        END
    END
RETURN

*------------------------------------------------------------------------------------------------------
CHECK.TT.TXN.STATUS:
*------------------------------------------------------------------------------------------------------

    R.TELLER.NAU = ''
    TELLER.NAU.ERR = ''
    CALL F.READ(FN.TELLER.NAU,T24.TXN.REF,R.TELLER.NAU,F.TELLER.NAU,TELLER.NAU.ERR)
    IF R.TELLER.NAU NE "" THEN
        R.TXN.RECORD.NAU = R.TELLER.NAU
        TXN.RECORD.STATUS = R.TELLER.NAU<TT.TE.RECORD.STATUS>
    END ELSE
        R.TELLER = ''
        TELLER.ERR = ''
        CALL F.READ(FN.TELLER,T24.TXN.REF,R.TELLER,F.TELLER,TELLER.ERR)
        IF R.TELLER NE "" THEN
            R.TXN.RECORD = R.TELLER
            TXN.RECORD.STATUS = R.TELLER<TT.TE.RECORD.STATUS>
        END ELSE
            HIS.FOUND.ERR = ''
            R.TXN.RECORD.HIS = ''
            CALL EB.READ.HISTORY.REC(F.TELLER.HIS,T24.TXN.REF,R.TXN.RECORD.HIS,HIS.FOUND.ERR)
            TXN.RECORD.STATUS = R.TXN.RECORD.HIS<TT.TE.RECORD.STATUS>
        END
    END
RETURN

*------------------------------------------------------------------------------------------------------
T24.TXN.REF.IN.NAU:
*------------------------------------------------------------------------------------------------------

    IF R.NEW(REDO.FXSN.FX.SEQ.STATUS) NE "AVAILABLE" THEN
        AF = REDO.FXSN.FX.SEQ.STATUS
        ETEXT = "EB-UNAUTH.RECORD.EXISTS"
        CALL STORE.END.ERROR
    END
RETURN

*------------------------------------------------------------------------------------------------------
T24.TXN.REF.IN.LIVE:
*------------------------------------------------------------------------------------------------------

    IF R.NEW(REDO.FXSN.FX.SEQ.STATUS) NE "ISSUED" THEN
        AF = REDO.FXSN.FX.SEQ.STATUS
        ETEXT = "EB-LIVE.EXIST.NO.MANUAL.UPD"
        CALL STORE.END.ERROR
    END
RETURN

*------------------------------------------------------------------------------------------------------
T24.TXN.REF.IN.HIS:
*------------------------------------------------------------------------------------------------------

    IF TXN.RECORD.STATUS EQ "REVE" AND R.NEW(REDO.FXSN.FX.SEQ.STATUS) NE "CANCELLED" THEN
        AF = REDO.FXSN.FX.SEQ.STATUS
        R.NEW(REDO.FXSN.FX.SEQ.STATUS) = "CANCELLED"
        ETEXT = "EB-FX.TXN.ID.IN.HIS"
        CALL STORE.END.ERROR
        RETURN
    END

    IF TXN.RECORD.STATUS EQ 'MAT' THEN
        AF = REDO.FXSN.FX.SEQ.STATUS
        R.NEW(REDO.FXSN.FX.SEQ.STATUS) = "ISSUED"
        ETEXT = "EB-FX.TXN.ID.IN.HIS"
        CALL STORE.END.ERROR
        RETURN
    END

RETURN

END
