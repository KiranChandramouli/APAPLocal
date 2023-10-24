* @ValidationCode : MjoyMDQ3ODE2MjQ0OkNwMTI1MjoxNjg2NTczODQxNTMxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jun 2023 18:14:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*12/06/2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION        INSERT FILE MODIFIED
*12/06/2023      SURESH                     MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.RAW.LOGGER(LOG.DIR,LOG.NAME,LOG.ARR)
*--------------------------------------------------------------------------------
* This subroutine creates a log file
*
*--------------------------------------------------------------------------------
* Incoming Variables
* LOG.DIR - Folder NAME under bnk.run directory, e.g.: APAP.LOG
* LOG.NAME - Name ID for the log, e.g.: TT21060J40LT, FT21060J40LT, L123456
* LOG.ARR - Array containing text to be logged.
* Outgoing Variables
*
*--------------------------------------------------------------------------------
    $INSERT I_EQUATE ;*AUTO R22 CODE CONVERSION
    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION

    IF NOT( GETENV('T24_HOME', t24_home) ) THEN
        CRT 'T24HOME not defined'
        STOP
    END
    V.DIR.OUT = t24_home:'/':LOG.DIR
    V.FILE.OUT =  LOG.NAME
    OPENSEQ V.DIR.OUT, V.FILE.OUT TO F.FILE.OUT THEN NULL

    LOOP
        REMOVE V.DATA FROM LOG.ARR SETTING V.STATUS
        T.MSG = TIMEDATE() :'|' : V.DATA
        WRITESEQ T.MSG APPEND TO F.FILE.OUT ELSE
            CRT 'Write error'
            STOP
        END
    UNTIL V.STATUS EQ 0
    REPEAT

END
