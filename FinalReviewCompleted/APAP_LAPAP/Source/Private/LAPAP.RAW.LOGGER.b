* @ValidationCode : MjoyMDQ3ODE2MjQ0OkNwMTI1MjoxNjg2Njc0MjY1MzU3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:07:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
