* @ValidationCode : MjoxMjY3ODUwNzQ0OkNwMTI1MjoxNjg5MzM4Mzg0NjY2OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jul 2023 18:09:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE			            AUTHOR		           Modification                            DESCRIPTION
*13/07/2023	               CONVERSION TOOL     AUTO R22 CODE CONVERSION		 T24.BP & USPLATFORM.BP is removed in insertfile,  $INCLUDE to $INSERT, VM TO @VM, ++ TO +=1
*13/07/2023	               VIGNESHWARI         MANUAL R22 CODE CONVERSION		      NOCHANGE
*-----------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.CHECK.REVERSAL.DELETE
*-----------------------------------------------------------------
*Description: This routine is to restrict the user from delete the RNAU TFS record when
*             underlying TT record is in RNAU. As per TFS module, in order to do reversal deletion,
*             we need to first delete the underlying RNAU TT record by setting the REVERSAL.MARK as R,
*             then it will move the TT RNAU record to LIVE. then we need to delete the TFS record.


    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION-START
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.T24.FUND.SERVICES ;*AUTO R22 CODE CONVERSION-END


    IF V$FUNCTION EQ "D" THEN
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END

RETURN
*-----------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------

    FN.TELLER$NAU = "F.TELLER$NAU"
    F.TELLER$NAU  = ""
    CALL OPF(FN.TELLER$NAU,F.TELLER$NAU)


RETURN
*-----------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------

    Y.UNDERLYING.TXNS = R.NEW(TFS.UNDERLYING)
    Y.UNDERLYING.CNT  = DCOUNT(Y.UNDERLYING.TXNS,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.UNDERLYING.CNT
        Y.TT.ID = Y.UNDERLYING.TXNS<1,Y.VAR1>
        CALL F.READ(FN.TELLER$NAU,Y.TT.ID,R.TELLER.NAU,F.TELLER$NAU,TT.ERR)
        IF R.TELLER.NAU<TT.TE.RECORD.STATUS>[1,2] EQ "RN" THEN
            AF = TFS.UNDERLYING
            AV = Y.VAR1
            ETEXT = "EB-REDO.TFS.TT.RNAU"
            CALL STORE.END.ERROR
            Y.VAR1 = Y.UNDERLYING.CNT+1 ;* Instead of break statement.
        END
        Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN
END
