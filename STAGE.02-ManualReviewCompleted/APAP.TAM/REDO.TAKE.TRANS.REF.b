* @ValidationCode : MjotMTcwMzE5NDY4MjpDcDEyNTI6MTY4MTg4ODE3MTA2NzpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 12:39:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TAKE.TRANS.REF

*--------------------------------------------------------------------------------
*Company   Name    : Asociacion Popular de Ahorros y Prestamos
*Developed By      : Shiva Prasad
*Program   Name    : REDO.TAKE.TRANS.REF
*IN DATA           : O.DATA
*OUT DATA          : O.DATA
*---------------------------------------------------------------------------------

*DESCRIPTION       : This Routine has been attached to the Enquiry for returning
*                    the Trans Reference value
* ----------------------------------------------------------------------------------
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*---------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.ENTRY

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    CALL F.READ(FN.STMT.ENTRY,O.DATA,R.STMT.REC,F.STMT.ENTRY,STMT.ERR)
    IF NOT(STMT.ERR) THEN
        TRANS.REF = R.STMT.REC<AC.STE.TRANS.REFERENCE>
        O.DATA = FIELD(TRANS.REF,'\',1)

    END
RETURN
END
