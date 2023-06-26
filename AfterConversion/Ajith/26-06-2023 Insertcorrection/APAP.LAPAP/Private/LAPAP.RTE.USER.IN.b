$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.RTE.USER.IN(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :LAPAP.RTE.USER.IN
*---------------------------------------------------------------------------------
*DESCRIPTION       : Obtiene el usuario INPUTTER de la transación RTE
* ----------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*26-06-2023       Conversion Tool           R22 Auto Code conversion          No Changes
*26-06-2023       S.AJITHKUMAR               R22 Manual Code Conversion       T24.BP IS REMOVED ,Command this Insert file I_F.T24.FUND.SERVICES
    $INSERT I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_REDO.DEAL.SLIP.COMMON
    $INSERT  I_F.TELLER
* $INSERT  I_F.FUNDS.TRANSFER ;*R22 manual code conversion
    $INSERT  I_F.T24.FUND.SERVICES
    $INSERT  I_F.USER
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
    Y.USUARIO = R.NEW(TT.TE.INPUTTER)
    Y.USUARIO = FIELD(Y.USUARIO, "_",2)
    Y.USER.ID = Y.USUARIO
    GOSUB GET.NAME.USER
RETURN

GET.USER.FT:

    Y.USUARIO = R.NEW(FT.INPUTTER)
    Y.USUARIO = FIELD(Y.USUARIO, "_",2)
    Y.USER.ID = Y.USUARIO
    GOSUB GET.NAME.USER
RETURN

GET.USER.TFS:
    Y.USUARIO = R.NEW(TFS.INPUTTER)
    Y.USUARIO = FIELD(Y.USUARIO, "_",2)
    Y.USER.ID = Y.USUARIO
    GOSUB GET.NAME.USER
RETURN


**************
GET.NAME.USER:
**************
    R.USER = ''; ERROR.USER = ''; Y.NAME.USER = ''
    CALL F.READ(FN.USER,Y.USER.ID,R.USER,FV.USER,ERROR.USER)
    Y.NAME.USER = R.USER<EB.USE.USER.NAME>

RETURN


END
