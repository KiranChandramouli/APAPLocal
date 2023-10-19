* @ValidationCode : MjotMTUwNzEzMDg3ODpDcDEyNTI6MTY4NDg1NDM5MzE0MTpJVFNTOi0xOi0xOi0xMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.MOVE.PART.PAY.HIST.SELECT
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH
* PROGRAM NAME : REDO.B.MOVE.PART.PAY.HIST.SELECT
*----------------------------------------------------------


* DESCRIPTION : This routine is used to select the records
* for processing each and every bill and moving them to
* history state
*------------------------------------------------------------

*    LINKED WITH : REDO.B.MOVE.PART.PAY.HIST.LOAD,REDO.B.MOVE.PART.PAY.HIST
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*31.05.2010      GANESH            ODR-2010-08-0017       INITIAL CREATION
* Date                  who                   Reference              
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------


*-------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.MOVE.PART.PAY.HIST.COMMON

*Selecting the records
    IF NOT(CONTROL.LIST) THEN
        CONTROL.LIST = "FT.LIST"
        CONTROL.LIST<-1> = "TT.LIST"
    END
    V.WORK.LIST = CONTROL.LIST<1,1>
    IF V.WORK.LIST EQ 'FT.LIST' THEN
        GOSUB FT.PROCESS
    END
    IF V.WORK.LIST EQ 'TT.LIST' THEN
        GOSUB TT.PROCESS
    END

FT.PROCESS:
    SEL.FT.REC = "SELECT " :FN.REDO.H.PART.PAY.FT
    CALL EB.READLIST(SEL.FT.REC,SEL.FT.LIST,'',NO.OF.FT.REC,FT.ERR)
    CALL BATCH.BUILD.LIST('',SEL.FT.LIST)
RETURN

TT.PROCESS:
    SEL.TT.REC = "SELECT " :FN.REDO.H.PART.PAY.TT
    CALL EB.READLIST(SEL.TT.REC,SEL.TT.LIST,'',NO.OF.TT.REC,TT.ERR)
    CALL BATCH.BUILD.LIST('',SEL.TT.LIST)
RETURN
END
