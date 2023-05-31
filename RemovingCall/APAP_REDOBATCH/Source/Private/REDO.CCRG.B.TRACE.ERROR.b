* @ValidationCode : MjotMTcyMjc4ODAwOTpDcDEyNTI6MTY4NDg1NDQwNjI0MTpJVFNTOi0xOi0xOjc2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 76
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CCRG.B.TRACE.ERROR(P.SOURCE.INFO, P.MSG, P.NON.FATAL, P.CUS.ID, P.LOG)
*-----------------------------------------------------------------------------
*  Routines used from TSA.SERVICE in Control Customer & Risk Group Limits
*             - translate the message to user's language
*             - save the message to logger
*             - call to FATAL.ERROR
*
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package redo.ccrg
*
* PARAMETERS:
*                     P.SOURCE.INFO (in)        Source Info.
*                                               SOURCE.INFO<1> => SOURCE.ROUTINE
*                                               SOURCE.INFO<2> => PARAGRAPH.NAME
*                                               SOURCE.INFO<3> => APPL.ID
*                                               SOURCE.INFO<4> => RECORD.KEY
*                                               SOURCE.INFO<5> => DESCRIPTION
*                                               SOURCE.INFO<6> => FIX.REQUIRED
*                                               SOURCE.INFO<7> => ERROR.CODE
*
*                     P.MSG         (in)        message variable parts
*                                               P.MSG<1> = "ST-RECORD.NOT.FOUND"
*                                               P.MSG<2> = "1021" : VM : "CUSTOMER"
*                     P.NON.FATAL   (in)        @TRUE this is not a FATAL.ERROR
*                     P.CUS.ID      (in)        Mandatory when P.LOG equals to @TRUE
*                     P.LOG         (in)        @TRUE save message in the log file
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - FM TO @FM AND = TO EQ
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*
*      IF P.NON.FATAL  THEN
*         P.SOURCE.INFO<8> = 'YES'
*      END

*     Get user message
    Y.TEXT = P.MSG<1>
    CALL EB.GET.ERROR.MESSAGE(Y.TEXT)
    IF Y.TEXT<1,1> EQ P.MSG<1> THEN
        Y.TEXT = P.MSG
    END ELSE
        Y.TEXT = Y.TEXT<1,1> : @FM : P.MSG<2>
    END

*     Translate message to user's language
    CALL TXT(Y.TEXT)
    CALL OCOMO(Y.TEXT)
*
*     Save log
    IF P.LOG THEN
        CALL S.REDO.CCRG.RL.SAVE.LOG(P.CUS.ID,P.SOURCE.INFO,Y.TEXT)
    END

*     Call FATAL.ERROR
    IF P.NON.FATAL EQ @FALSE THEN
        TEXT = Y.TEXT
        CALL FATAL.ERROR(P.SOURCE.INFO)
    END
RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

RETURN

*-----------------------------------------------------------------------------
END
