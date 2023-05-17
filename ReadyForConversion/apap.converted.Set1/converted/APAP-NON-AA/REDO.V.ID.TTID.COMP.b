SUBROUTINE REDO.V.ID.TTID.COMP
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: V NAVA
* PROGRAM NAME: REDO.V.ID.TTID.COMP
*----------------------------------------------------------------------
*DESCRIPTION: This routine is used to check that current Company of Teller ID (AUTHORISER)
*, does not belong to different Company of the "Target Teller ID" of current transaction.
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:   TELLER,REDO.LCY.FCY.TILLTFR.ML and ME, TELLER,REDO.VAULT.TO.TILL.LCY and ME versions.
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*06.08.2012     V.NAVA        PACS00186440     INITIAL CREATION
*02.09.2012     V.NAVA        PACS00186440     Adding validation when first autorization is
*                                              made (user logged) by different user teller Target (Cash receiver).
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.ID
    $INSERT I_F.TELLER
*
    IF V$FUNCTION EQ 'A' THEN
        GOSUB INIT
        GOSUB OPEN.FILES
        GOSUB GET.TTIDCO.TARGET
        GOSUB PROCESS
    END
*
RETURN
*
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*
    CALL F.READ(FN.TELLER.USER,Y.OPERA,R.TELLER.USER,F.TELLER.USER,Y.TR.)
    Y.TID.LIST     = R.TELLER.USER
    CHANGE @VM TO @FM IN Y.TID.LIST
    Y.ID.CNT       = DCOUNT(Y.TID.LIST,@FM)
*
    Y.ID.LOOP.CNT = 1
    LOOP
    WHILE Y.ID.LOOP.CNT LE Y.ID.CNT
        Y.TID.ID = ''
        Y.TID.ID = R.TELLER.USER<Y.ID.LOOP.CNT>
        GOSUB READ.TTID
        IF R.TID NE "" THEN
            Y.CURR.COMP = ''
            Y.CURR.COMP = R.TID<TT.TID.CO.CODE>
            Y.TID.STATS = ''
            Y.TID.STATS = R.TID<TT.TID.STATUS>
            IF Y.TID.COMP NE Y.CURR.COMP AND Y.TID.STATS EQ "CLOSE" THEN
                Y.FLG.ERR = 1
            END
*
            IF Y.TID.OP EQ Y.TID.ID THEN
                Y.FLG.IS = 1          ;* Current cashier is target cashier
            END
*
        END
        Y.ID.LOOP.CNT += 1
    REPEAT
*
    IF ( Y.FLG.ERR AND Y.FLG.IS EQ "" ) OR ( Y.FLG.IS EQ "" AND WREC.STATUS EQ "INAU" ) THEN
        E         = 'EB-TELLER.NOT.AUTH'
        CALL STORE.END.ERROR
    END
*
RETURN
*
*----------------------------------------------------------------------
READ.TTID:
*----------------------------------------------------------------------
*
    R.TID            = ''
    Y.ERR.TID        = ''
    CALL F.READ(FN.TID, Y.TID.ID, R.TID, F.TID, Y.ERR.TID)
*
RETURN
*
*----------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------
*
    CALL OPF(FN.TID, F.TID)
*
    CALL OPF(FN.TELLER.NAU, F.TELLER.NAU)
*
    CALL OPF(FN.TELLER.USER, F.TELLER.USER)
*
RETURN
*
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
*
    FN.TID           = 'F.TELLER.ID'
    F.TID            = ''
*
    FN.TELLER.NAU    = 'F.TELLER$NAU'
    F.TELLER.NAU     = ''
    R.TELLER.NAU     = ''
    Y.ERR.TNAU       = ''
*
    FN.TELLER.USER   = 'F.TELLER.USER'
    F.TELLER.USER    = ''
    R.TELLER.USER    = ''
    Y.ERR.TUSE       = ''
*
    Y.TTNAU.ID       = COMI
    Y.OPERA          = OPERATOR ;* Code Review 20120808
    Y.STATUS         = 1
    Y.TID.ID         = ''
    Y.TID.COMP       = ''
    Y.FLG.ERR        = ''
    Y.TID.OP         = ''
    Y.FLG.IS         = ''
    WREC.STATUS      = ''
*
RETURN
*
*----------------------------------------------------------------------
GET.TTIDCO.TARGET:
*----------------------------------------------------------------------
*
    CALL F.READ(FN.TELLER.NAU, Y.TTNAU.ID, R.TELLER.NAU, F.TELLER.NAU, Y.ERR.TNAU)
*
    IF R.TELLER.NAU<TT.TE.DR.CR.MARKER> EQ "DEBIT" THEN
        Y.TID.ID  = R.TELLER.NAU<TT.TE.TELLER.ID.1>
    END
    ELSE
        Y.TID.ID  = R.TELLER.NAU<TT.TE.TELLER.ID.2>
    END
*
    Y.TID.OP      = Y.TID.ID
    WREC.STATUS   = R.TELLER.NAU<TT.TE.RECORD.STATUS>
*
    GOSUB READ.TTID
    IF R.TID NE "" THEN
        Y.TID.COMP = R.TID<TT.TID.CO.CODE>
    END
*
RETURN
*
END
