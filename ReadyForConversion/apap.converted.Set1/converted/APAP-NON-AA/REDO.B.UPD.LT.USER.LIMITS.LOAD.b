SUBROUTINE REDO.B.UPD.LT.USER.LIMITS.LOAD
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.B.UPD.LT.USER.LIMITS.LOAD
*--------------------------------------------------------------------------------------------------------
*Description       : The routine is the .LOAD routine for the multithreade batch routine
*                    REDO.B.UPD.LT.USER.LIMITS. The files are opened in this section
*In Parameter      : NA
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                            Reference                      Description
*   ------         ------                         -------------                    -------------
*  08/11/2010   Jeyachandran S                     ODR-2010-07-0075                Initial Creation
*  09/05/2011   Pradeep S                          PACS00037714                    New file created to back up the
*                                                                                  User daily txn details
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.USER.LIMITS
    $INSERT I_F.DATES
    $INSERT I_F.REDO.APAP.FX.BRN.POSN
    $INSERT I_F.REDO.APAP.FX.BRN.COND
    $INSERT I_REDO.B.UPD.LT.USER.LIMITS.COMMON

    GOSUB INITIALISE
RETURN

*--------------------------------------------------------------------------------------------------------
INITIALISE:
*------------
* Initialise/Open all necessary variable/files

    FN.REDO.APAP.USER.LIMITS = 'F.REDO.APAP.USER.LIMITS'
    F.REDO.APAP.USER.LIMITS = ''
    CALL OPF(FN.REDO.APAP.USER.LIMITS,F.REDO.APAP.USER.LIMITS)

    FN.DATES = 'F.DATES'
    F.DATES = ''
    CALL OPF(FN.DATES,F.DATES)

    FN.REDO.APAP.FX.BRN.POSN = 'F.REDO.APAP.FX.BRN.POSN'
    F.REDO.APAP.FX.BRN.POSN = ''
    CALL OPF(FN.REDO.APAP.FX.BRN.POSN,F.REDO.APAP.FX.BRN.POSN)

    FN.REDO.APAP.FX.BRN.COND = 'F.REDO.APAP.FX.BRN.COND'
    F.REDO.APAP.FX.BRN.COND = ''
    CALL OPF(FN.REDO.APAP.FX.BRN.COND,F.REDO.APAP.FX.BRN.COND)

*PACS00037714 - S
    FN.REDO.APAP.USER.TXN.DTLS = 'F.REDO.APAP.USER.TXN.DTLS'
    F.REDO.APAP.USER.TXN.DTLS = ''
    CALL OPF(FN.REDO.APAP.USER.TXN.DTLS,F.REDO.APAP.USER.TXN.DTLS)
    Y.ID2 = "SYSTEM"
    CALL CACHE.READ(FN.REDO.APAP.FX.BRN.COND,Y.ID2,R.REDO.APAP.FX.BRN.COND,ERR)
*PACS00037714 - E

RETURN

*--------------------------------------------------------------------------------------------------------
END
