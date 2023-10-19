* @ValidationCode : MjoxMzIzMjExNzk6Q3AxMjUyOjE2ODE4ODY5OTI5OTQ6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Apr 2023 12:19:52
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.VP.UTIL.LOG(FILE.NAME, FILE.PATH, LOG.MSG)
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 04.30.2013
* Description  : Utilitary routine for generating log file
* Type         : Util Routine
* Attached to  : -
* Dependencies : NA
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
 
* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.VISION.PLUS.PARAM

* </region>

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************

RETURN

***********************
* Open Files
OPEN.FILES:
***********************

RETURN

***********************
* Main Process
PROCESS:
***********************
* Open File Directory
    OPEN FILE.PATH ELSE

        CRT 'ERROR IN OPENING LOG FILE PATH!'
        RETURN
    END

* Open File
    FILE.PATH := '/' : FILE.NAME
    OPENSEQ FILE.PATH TO LOG.FILE THEN
        CRT 'LOG FILE ALREADY EXISTS ' : FILE.PATH
        WEOFSEQ LOG.FILE
    END

* Write File
    LOOP
        REMOVE Y.LINE FROM LOG.MSG SETTING Y.LINE.POS
    WHILE Y.LINE:Y.LINE.POS
        WRITESEQ Y.LINE TO LOG.FILE ELSE
            CRT 'UNABLE TO WRITE IN LOG FILE ' : FILE.PATH
            BREAK
        END
    REPEAT

* Close File
    CLOSESEQ LOG.FILE

RETURN

* </region>

END
