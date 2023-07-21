* @ValidationCode : MjotNzE3NzUzNTI5OkNwMTI1MjoxNjg5OTI1MjQ1MTI3OklUU1M6LTE6LTE6NDkwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Jul 2023 13:10:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 490
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE			               AUTHOR			Modification                            DESCRIPTION
*13/07/2023	               CONVERSION TOOL      AUTO R22 CODE CONVERSION			      NOCHANGE
*13/07/2023	               VIGNESHWARI   	    MANUAL R22 CODE CONVERSION		         INSERT FILE IS ADDED 
*-----------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.GET.ACC.CO.CODE(ACCOUNT.VAL,Y.ACC.CO.CODE)
*----------------------------------------------------------------
* Description: This call routine will return company code of account or alternate id passed.
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ALTERNATE.ACCOUNT ;*MANUAL R22 CODE CONVERSION- INSERT FILE IS ADDED


    GOSUB PROCESS
RETURN
*----------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT  = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    Y.ACC.CO.CODE = ''
    Y.ACC.ID = ACCOUNT.VAL
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)
    IF R.ACC THEN
        Y.ACC.CO.CODE = R.ACC<AC.CO.CODE>
    END ELSE
        Y.ALT.ID = FMT(Y.ACC.ID,'11"0"R')
        CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.ALT.ID,R.ALTERNATE.ACC,F.ALTERNATE.ACCOUNT,ALT.ERR)
        IF R.ALTERNATE.ACC THEN
*      Y.ACC.ID = R.ALTERNATE.ACC<1>


* Tus Start
            Y.ACC.ID = R.ALTERNATE.ACC<AAC.GLOBUS.ACCT.NUMBER> 
* Tus End
            CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)
            IF R.ACC THEN
                Y.ACC.CO.CODE = R.ACC<AC.CO.CODE>
            END ELSE
                Y.ACC.CO.CODE = ID.COMPANY
            END
        END ELSE
            Y.ACC.CO.CODE = ID.COMPANY
        END

    END
RETURN
END
