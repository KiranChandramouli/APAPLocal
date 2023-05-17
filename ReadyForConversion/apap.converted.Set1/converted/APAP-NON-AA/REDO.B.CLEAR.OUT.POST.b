SUBROUTINE REDO.B.CLEAR.OUT.POST

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Arulprakasam P
* Program Name  : REDO.B.CLEAR.OUT.POST
*-------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*
*-----------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------------
*   DATE                ODR                             DESCRIPTION
* 23-11-2010      ODR-2010-09-0251                  Initial Creation
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.APAP.CLEARING.INWARD
    $INSERT I_F.REDO.MAPPING.TABLE
    $INSERT I_F.REDO.CLEARING.PROCESS
    $INSERT I_REDO.B.CLEAR.OUT.COMMON
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_F.REDO.COLLECT.PARAM


    CLEARING.PROCESS.ID = 'B132.PROCESS'

    FN.REDO.CLEARING.PROCESS = 'F.REDO.CLEARING.PROCESS'
    F.REDO.CLEARING.PROCESS = ''
    CALL OPF(FN.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS)


    CALL CACHE.READ(FN.REDO.CLEARING.PROCESS,CLEARING.PROCESS.ID,R.REDO.CLEARING.PROCESS,Y.ERR)
    VAR.FILE.PATH = R.REDO.CLEARING.PROCESS<PRE.PROCESS.OUT.PROCESS.PATH>
    SEL.CMD = "SELECT ":VAR.FILE.PATH
    CALL EB.READLIST(SEL.CMD,FILE.LIST,'',NO.OF.REC,RET.ERR)

    LOOP
        REMOVE VAR.APERTA.ID FROM FILE.LIST SETTING FILE.POS
    WHILE VAR.APERTA.ID:FILE.POS

        DAEMON.CMD = "DELETE ":VAR.FILE.PATH:" ":VAR.APERTA.ID
        EXECUTE DAEMON.CMD

    REPEAT

RETURN
END
