SUBROUTINE REDO.V.ID.COLL.STAT
************************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: V NAVA
* PROGRAM NAME: REDO.V.ID.COLL.STAT
*-----------------------------------------------------------------------
*DESCRIPTION: This routine is used to check whether CO status is CANCELLED and avoid any updation.
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:   COLLATERAL,REDO.INGRESO.XXX and COLLATERAL,REDO.MODIFICA.XXX versions.
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10.SEP.2013    V.NAVA        PACS00306800     INITIAL CREATION
*
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
*
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS
*
RETURN
*
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*
    Y.ERR.CO = '' ; R.COLLATERAL = ''
    CALL F.READ(FN.COLLATERAL, Y.CO.ID, R.COLLATERAL, F.COLLATERAL, Y.ERR.CO)
    Y.COL.STATUS = R.COLLATERAL<COLL.LOCAL.REF,WPOSCOST>
*
    IF Y.COL.STATUS EQ "CANCELLED" AND Y.TXN.FUNC NE 'S' THEN
        E="EB-TRANSACTION.NOT.ALLOWED"
        CALL STORE.END.ERROR
    END
*
RETURN
*
*----------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------
*
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
*
RETURN
*
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
*
    Y.CO.ID         = COMI
    Y.TXN.FUNC      = V$FUNCTION
*
    FN.COLLATERAL    = 'F.COLLATERAL'
    F.COLLATERAL     = ''
    R.COLLATERAL     = ''
*
    WCAMPO = "L.COL.SEC.STA"
    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

    WPOSCOST = YPOS<1,1>

RETURN
*
END
