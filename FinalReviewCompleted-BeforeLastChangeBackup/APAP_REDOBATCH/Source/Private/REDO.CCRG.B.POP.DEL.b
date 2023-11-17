* @ValidationCode : MjoyODI0NTI5NTpDcDEyNTI6MTY4MDc5MDExMDcyMjpJVFNTOi0xOi0xOjg3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 87
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CCRG.B.POP.DEL(P.IN.CUS.ID)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description   : part of REDO.CCRG.B.POP TSA service
* Linked With   : TSA.SERVICE - ID: REDO.CCRG.POP
* In Parameter  : P.IN.CUS.ID - Customer code of the customer consulted
* Out Parameter :
*--------------------------------------------------------------------------------------------
* Modification Details:
*--------------------------------------------------------------------------------------------
* 27-09-2011 - Creation               hpasquel@temenos.com
*--------------------------------------------------------------------------------------------
* Modification History
* Company Name: APAP
* Developed By: Temenos Application Management
* Program Name: REDO.CCRG
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.CCRG.B.POP.COMMON
*--------------------------------------------------------------------------------------------

    GOSUB PROCESS
RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------
* Delete for P.IN.CUS.ID
*
    CALL F.DELETE(FN.REDO.CCRG.RL.BAL.MAIN,P.IN.CUS.ID)
*
    Y.FILE.NAME    = FN.REDO.CCRG.RL.BAL.DET
    Y.FILE.NAME<2> = 'CUSTOMER.ID EQ ' : P.IN.CUS.ID
    CALL EB.CLEAR.FILE(Y.FILE.NAME, F.REDO.CCRG.RL.BAL.DET)
*
    Y.FILE.NAME    = FN.REDO.CCRG.RL.BAL.CUS.DET
    Y.FILE.NAME<2> = 'CUSTOMER.ID EQ ' : P.IN.CUS.ID
    CALL EB.CLEAR.FILE(Y.FILE.NAME, F.REDO.CCRG.RL.BAL.CUS.DET)

RETURN
*-----------------------------------------------------------------------------
END
