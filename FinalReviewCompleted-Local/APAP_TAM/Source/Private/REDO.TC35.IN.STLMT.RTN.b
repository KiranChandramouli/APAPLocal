* @ValidationCode : MjotMTQzNTI1Njc5NjpDcDEyNTI6MTY4MzcyODg2NTQxNDpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 May 2023 19:57:45
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
SUBROUTINE REDO.TC35.IN.STLMT.RTN(STLMT.LINES)
*----------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.TC35.IN.STLMT.RTN
*****************************************************************
*Description:
*----------------
*TC 35,36,37 represents the reversal of chargeback raised by us in the case of duplicate
*Start the routine with one incoming parameter STLMT.LINES
*-----------------------------------------------------------------------------------------------------
*In Parameter : None
*Out Parameter : None
************************************************************************
*Modification History:
***********************
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   2-12-2010       DHAMU S              ODR-2010-08-0469         Initial Creation
*   10.04.2023      Conversion Tool       R22                     Auto Conversion     - No changes
*   10.04.2023      Shanmugapriya M       R22                     Manual Conversion   - Add call routine prefix
*
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
	$USING APAP.TAM


    GOSUB PROCESS

RETURN

********
PROCESS:
*********
*CALL REDO.TC.IN.FRAME.ARR(STLMT.LINES)
** R22 Manual conversion
    CALL APAP.TAM.redoTcInFrameArr(STLMT.LINES)
*CALL REDO.TC35.IN.VERIFY.RTN
** R22 Manual conversion
    CALL APAP.TAM.redoTc35InVerifyRtn()
    R.REDO.STLMT.LINE<VISA.SETTLE.FINAL.STATUS> = 'SETTLED'
    R.REDO.STLMT.LINE<VISA.SETTLE.FILE.DATE>=Y.FILE.DATE
    CALL LOAD.COMPANY(ID.COMPANY)
    FULL.FNAME = 'F.REDO.VISA.STLMT.05TO37'
    ID.T  = 'A'
    ID.N ='15'
    ID.CONCATFILE = ''
    COMI = ''
    PGM.TYPE = '.IDA'
    ID.NEW = ''
    V$FUNCTION = 'I'
    ID.NEW.LAST = ''
    CALL GET.NEXT.ID(ID.NEW.LAST,'F')
    Y.ID = COMI
*CALL REDO.VISA.SETTLE.WRITE(Y.ID,R.REDO.STLMT.LINE)
** R22 Manual conversion
    CALL APAP.TAM.redoVisaSettleWrite(Y.ID,R.REDO.STLMT.LINE)

RETURN


END
