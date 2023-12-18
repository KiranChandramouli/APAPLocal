* @ValidationCode : MjoxMTAwMDE3OTkyOkNwMTI1MjoxNjkzMzEzNzYxNDgwOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 29 Aug 2023 18:26:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*25-08-2023     VIGNESHWARI S       R22 MANUAL CONVERSION   PATH IS MODIFIED
*13-12-2023     Edwin C             R22 Manual Conversion   COB Issue Fix
*----------------------------------------------------------------------------------------

SUBROUTINE REDO.SAP.CLEAR.FILE

* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By :
* Program Name :
*-----------------------------------------------------------------------------
* Description : For clearing the SAP directory during COB
* Linked with :
* In Parameter :
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*09/10/11       PACS00071961            PRABHU N                MODIFICAION
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON 
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER


    GOSUB OPEN.FILE
    GOSUB READ.PARAM.FILE
    GOSUB TAKE.BACKUP
    GOSUB CLEAR.SAP.DIR

RETURN
*---------*
OPEN.FILE:
*---------*

    FN.REDO.GL.H.EXTRACT.PARAMETER = 'F.REDO.GL.H.EXTRACT.PARAMETER'
    F.REDO.GL.H.EXTRACT.PARAMETER  = ''
    CALL OPF(FN.REDO.GL.H.EXTRACT.PARAMETER,F.REDO.GL.H.EXTRACT.PARAMETER)

RETURN
*---------------*
READ.PARAM.FILE:
*----------------
    R.REDO.GL.H.EXTRACT.PARAMETER  = ''
    REDO.GL.H.EXTRACT.PARAMETER.ER = ''
    CALL CACHE.READ(FN.REDO.GL.H.EXTRACT.PARAMETER,'SYSTEM',R.REDO.GL.H.EXTRACT.PARAMETER,REDO.GL.H.EXTRACT.PARAMETER.ER)

RETURN
*--------------*
TAKE.BACKUP:
*--------------*

    BACKUP.DIR = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.BACKUP.PATH>
    SOURCE.DIR = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXTRACT.OUT.PATH,1>

*    COPY.CMD = "COPY FROM ":SOURCE.DIR:" TO ":BACKUP.DIR:" ALL"
*    COPY.CMD = 'SH -c cp ':SOURCE.DIR: '/':" ALL":' ':BACKUP.DIR:'/':" ALL" ;* R22 MANUAL CONVERSION - PATH IS MODIFIED
     COPY.CMD = 'SH -c cp ':SOURCE.DIR:"/*":' ':BACKUP.DIR:'/' ;* R22 MANUAL CONVERSION - PATH IS MODIFIED	 ;*COB Issue Fix
*	 cp ../interface/SAPRPT/* COPYTEST.BP/COPY/     ; * sample statement
    EXECUTE COPY.CMD


RETURN

*--------------*
CLEAR.SAP.DIR:
*--------------*
    CLEAR.DIR= R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXTRACT.OUT.PATH,1>
    EXE.CMD = 'CLEAR.FILE ':CLEAR.DIR
    EXECUTE EXE.CMD

RETURN

END
