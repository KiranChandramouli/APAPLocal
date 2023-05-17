SUBROUTINE REDO.BRR.INWRETURN.PROCESS.LOAD
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : NATCHIMUTHU
* Program Name  : REDO.BRR.INWRETURN.PROCESS.LOAD
* ODR           : ODR-2010-09-0148.
*-------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*
*---------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*-------------------------------------------------------------------------
*   DATE              ODR              WHO                   DESCRIPTION
* 30-09-10          ODR-2010-09-0148   NATCHIMUTHU           Initial Creation
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.APAP.CLEARING.INWARD
    $INSERT I_F.REDO.MAPPING.TABLE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.CLEARING.PROCESS
    $INSERT I_REDO.BRR.INWRETURN.PROCESS.COMMON

    GOSUB INIT
RETURN

*******
INIT:
*******


    FN.REDO.CLEARING.PROCESS = 'F.REDO.CLEARING.PROCESS'
    F.REDO.CLEARING.PROCESS  = ''
    CALL OPF(FN.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS)

    FN.REDO.MAPPING.TABLE = 'F.REDO.MAPPING.TABLE'
    F.REDO.MAPPING.TABLE = ''
    CALL OPF(FN.REDO.MAPPING.TABLE,F.REDO.MAPPING.TABLE)

    FN.REDO.APAP.CLEARING.INWARD = 'F.REDO.APAP.CLEARING.INWARD'
    F.REDO.APAP.CLEARING.INWARD = ''
    CALL OPF(FN.REDO.APAP.CLEARING.INWARD,F.REDO.APAP.CLEARING.INWARD)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.REJECT.REASON =  'F.REDO.REJECT.REASON'
    F.REDO.REJECT.REASON  =  ''
    CALL OPF(FN.REDO.REJECT.REASON,F.REDO.REJECT.REASON)


    F.PATH = ''

    Y.FINAL.ARRAY = ''

    Y.FILE.PATH = ''

    Y.FILE.NAME = ''

RETURN
*-------------------------------------------------------------------------------------
END
*---------------------------------------------------------------------------------------
