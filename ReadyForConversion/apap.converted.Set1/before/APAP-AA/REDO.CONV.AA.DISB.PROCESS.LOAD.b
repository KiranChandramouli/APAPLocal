*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.CONV.AA.DISB.PROCESS.LOAD
*-------------------------------------------------
*Description:
*-------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.CONV.AA.DISB.PROCESS.COMMON

******
INIT:
******
*Initialise all the variable

    FN.REDO.DISB.CHAIN = 'F.REDO.DISB.CHAIN'
    F.REDO.DISB.CHAIN = ''
    CALL OPF(FN.REDO.DISB.CHAIN, F.REDO.DISB.CHAIN)

    FN.TEMP.FILE.PATH = '../EXTRACT/MASSIVE.BP/temp1'
    OPEN FN.TEMP.FILE.PATH TO F.TEMP.FILE.PATH ELSE
        Y.MK.CMD = "mkdir ../EXTRACT/MASSIVE.BP/temp1"
        EXECUTE Y.MK.CMD
        OPEN FN.TEMP.FILE.PATH TO F.TEMP.FILE.PATH ELSE
        END
    END

    FN.EXP.FILE.PATH = '../EXTRACT/MASSIVE.BP/CONVERSE.BP'
    OPEN FN.EXP.FILE.PATH TO F.EXP.FILE.PATH ELSE
        Y.MK.CMD = "mkdir ../EXTRACT/MASSIVE.BP/CONVERSE.BP"
        EXECUTE Y.MK.CMD
        OPEN FN.EXP.FILE.PATH TO F.EXP.FILE.PATH ELSE
        END
    END

    Y.DATE = TODAY
    Y.FILE.NAME = 'AA.CONV.':Y.DATE:'.csv'

    RETURN
END
