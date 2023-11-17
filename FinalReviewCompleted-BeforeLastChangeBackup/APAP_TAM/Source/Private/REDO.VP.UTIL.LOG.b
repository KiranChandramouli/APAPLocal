* @ValidationCode : MjoxMzIzMjExNzk6Q3AxMjUyOjE2ODQ4NDIxNTI5OTQ6SVRTUzotMTotMTozNzA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 370
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
