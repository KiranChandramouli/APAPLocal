* @ValidationCode : MjotNTk4MTQxNjE1OkNwMTI1MjoxNjgwNjc3NTIxOTIwOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:22:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
SUBROUTINE DR.REG.INT.TAX.PAYMENT(REC.ID)
*-------------------------------------------------------------------------
* Date              Author                 Description
* ==========        ==============        ============
* 01-Aug-2014     V.P.Ashokkumar          PACS00305231 - Added EB.READ.HIST.REC for account.
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   = to EQ
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE

*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STMT.ACCT.CR
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY

    $INSERT I_DR.REG.INT.TAX.PAYMENT.COMMON
    $INSERT I_DR.REG.INT.TAX.COMMON
*----------------------------------------------------------------------------------------
* Interest payment and tax withheld information for the day
*----------------------------------------------------------------------------------------
    GOSUB PROCESS

RETURN

PROCESS:
*------*

    GOSUB READ.RECORDS
    GOSUB RUN.PROCESS
RETURN

READ.RECORDS:
*-----------*
    R.STMT.ACCT.CR = ''; STMT.ACCT.CR.ERR = ''
    CALL F.READ(FN.STMT.ACCT.CR,REC.ID,R.STMT.ACCT.CR,F.STMT.ACCT.CR,STMT.ACCT.CR.ERR)
    RCL$INT.TAX(1) = R.STMT.ACCT.CR
    AC.ID = FIELD(REC.ID,'-',1)
    R.ACCOUNT = ''; ACCOUNT.ERR = ''; CUS.ID = ''
    CALL F.READ(FN.ACCOUNT,AC.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
* Byron PACS00305231/start
    IF R.ACCOUNT EQ "" OR R.ACCOUNT<AC.CUSTOMER> EQ "" THEN ;*R22 AUTO CODE CONVERSION
*        AC.HIS.ID = AC.ID:";1"
*        CALL F.READ(FN.ACCOUNT$HIS,AC.HIS.ID,R.ACCOUNT,F.ACCOUNT$HIS,ACCOUNT.HIS.ERR)
        CALL EB.READ.HISTORY.REC(F.ACCOUNT$HIS,AC.ID,R.ACCOUNT,ACCOUNT.HIS.ERR)
    END
    RCL$INT.TAX(2) = R.ACCOUNT
    CUS.ID = R.ACCOUNT<AC.CUSTOMER>
    R.CUSTOMER = ''; CUSTOMER.ERR = ''
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    RCL$INT.TAX(3) = R.CUSTOMER
RETURN

RUN.PROCESS:
*---------*

    RCL.MAP.FMT    = "MAP"
    RCL.ID         = "DR.REG.INT.TAX.PAY"
    RCL.BASE.APP   = FN.STMT.ACCT.CR
    RCL.BASE.ID    = REC.ID
    RCL.BASE.R.REC = R.STMT.ACCT.CR
    RETURN.MSG     = ""
    ERROR.MSG      = ""
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(RCL.MAP.FMT, RCL.ID, RCL.BASE.APP, RCL.BASE.ID, RCL.BASE.R.REC, RETURN.MSG, ERROR.MSG)
    IF RETURN.MSG THEN
        CALL F.WRITE(FN.DR.REG.INT.TAX.PAYMENT.WORKFILE,REC.ID,RETURN.MSG)
    END
RETURN
*----------------------------------------------------------------------------------------
*Final end
END
