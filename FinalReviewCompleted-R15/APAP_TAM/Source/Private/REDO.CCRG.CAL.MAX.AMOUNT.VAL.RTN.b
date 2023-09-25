* @ValidationCode : MjotMjA4MjgyMzQxNzpDcDEyNTI6MTY4OTkyNTI0NDQ0MTpJVFNTOi0xOi0xOi03OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Jul 2023 13:10:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE			           AUTHOR			          Modification                            DESCRIPTION
*13/07/2023	               CONVERSION TOOL         AUTO R22 CODE CONVERSION			          NOCHANGE
*13/07/2023	               VIGNESHWARI      	    MANUAL R22 CODE CONVERSION		          CALL ROUTINE MODIFIED,insert is added
*-----------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.CCRG.CAL.MAX.AMOUNT.VAL.RTN
*-----------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    anoriega@temenos.com
* @stereotype subroutine: Validate Routine VERSION REDO.CCRG.RISK.LIMIT.PARAM,MAN FIELD percentage
* @package:   REDO.CCRG
*!
*-----------------------------------------------------------------------------
*  This routine validate the percentage value and calculate the maximo ammount
*  by the Risk Limit IN process
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CCRG.TECHNICAL.RESERVES
    $INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM ;*MANUAL R22 CODE CONVERSION-Insert is added
*-----------------------------------------------------------------------------

    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:

    IF ID.NEW EQ 'HOUSING.PLAN.APAP' THEN
        TEC.RES.ID = 'SYSTEM'
        R.TECH.RES = ''
        YERR       = ''
        CALL CACHE.READ('F.REDO.CCRG.TECHNICAL.RESERVES',TEC.RES.ID,R.TECH.RES,YERR)

        IF R.TECH.RES THEN
            Y.AMOUNT.TEC.RES =R.TECH.RES<REDO.CCRG.TR.TECH.RES.AMOUNT>
            Y.PORCEN.CAL = COMI * 100 /Y.AMOUNT.TEC.RES
            
            R.NEW(REDO.CCRG.RLP.PERCENTAGE) = Y.PORCEN.CAL 
        END

    END ELSE
        APAP.TAM.redoCcrgCalMaxAmount('VAL.RTN');*MANUAL R22 CODE CONVERSION
    END

RETURN

END
