SUBROUTINE LAPAP.RTE.USER.AUTH(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :LAPAP.RTE.USER.AUTH
*---------------------------------------------------------------------------------
*DESCRIPTION       : Obtiene el usuario que autorizo el override de alerta RTE
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.DEAL.SLIP.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.USER
    GOSUB PROCESS
RETURN

OPEN.APLICATION:
    FN.USER = 'F.USER'; FV.USER = ''
    CALL OPF (FN.USER,FV.USER)

RETURN
*********
PROCESS:
*********
    GOSUB OPEN.APLICATION

    BEGIN CASE

        CASE ID.NEW[1,2] EQ 'TT'
            GOSUB GET.USER.TT
        CASE ID.NEW[1,2] EQ 'FT'
            GOSUB GET.USER.FT
        CASE ID.NEW[1,5] EQ 'T24FS'
            GOSUB GET.USER.TFS

    END CASE

    Y.OUT = " ":Y.USER.ID:" ":Y.NAME.USER
RETURN

************
GET.USER.TT:
************
    Y.OVERRIDE = R.NEW(TT.TE.OVERRIDE)
    Y.CNT = DCOUNT(Y.OVERRIDE,@VM)
    FOR I.VAR = 1 TO Y.CNT
        Y.DESCRIPCION.RTE = Y.OVERRIDE<1,I.VAR>
        Y.USUARIO = ''
        FINDSTR "(RTE)" IN Y.DESCRIPCION.RTE SETTING Ap, Vp THEN
            Y.USUARIO = FIELD(Y.DESCRIPCION.RTE,@SM,3)
            Y.USUARIO = FIELD(Y.USUARIO,"_",1)
            Y.USER.ID = Y.USUARIO
            GOSUB GET.NAME.USER
            BREAK
        END
    NEXT I.VAR
RETURN
**************
GET.USER.FT:
**************
    Y.OVERRIDE = R.NEW(FT.OVERRIDE)
    Y.CNT = DCOUNT(Y.OVERRIDE,@VM)
    FOR I.VAR = 1 TO Y.CNT
        Y.DESCRIPCION.RTE =  Y.OVERRIDE<1,I.VAR>
        FINDSTR "(RTE)" IN Y.DESCRIPCION.RTE SETTING Ap, Vp THEN
            Y.USUARIO = FIELD(Y.DESCRIPCION.RTE,@SM,3)
            Y.USUARIO = FIELD(Y.USUARIO,"_",1)
            Y.USER.ID = Y.USUARIO
            GOSUB GET.NAME.USER
            BREAK
        END
    NEXT I.VAR
RETURN
**************
GET.USER.TFS:
**************
    Y.OVERRIDE = R.NEW(TFS.OVERRIDE)
    Y.CNT = DCOUNT(Y.OVERRIDE,@VM)
    FOR I.VAR = 1 TO Y.CNT
        Y.DESCRIPCION.RTE =  Y.OVERRIDE<1,I.VAR>
        FINDSTR "(RTE)" IN Y.DESCRIPCION.RTE SETTING Ap, Vp THEN
            Y.USUARIO = FIELD(Y.DESCRIPCION.RTE,@SM,3)
            Y.USUARIO = FIELD(Y.USUARIO,"_",1)
            GOSUB GET.NAME.USER
            BREAK
        END
    NEXT I.VAR
RETURN


**************
GET.NAME.USER:
**************
    R.USER = ''; ERROR.USER = ''; Y.NAME.USER = ''
    CALL CACHE.READ(FN.USER, Y.USER.ID, R.USER, ERROR.USER)
    Y.NAME.USER = R.USER<EB.USE.USER.NAME>

RETURN


END
