* @ValidationCode : MjoxNjUzMDc5MTc1OkNwMTI1MjoxNzA0MzcxMjM3NTk1OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jan 2024 17:57:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.PRE.DD.PROCESS
*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.POST.DD.PROCESS
* Primary Purpose : Clearing FT record from the template 'REDO.W.DIRECT.DEBIT'
* MODIFICATION HISTORY
*-------------------------------
*-----------------------------------------------------------------------------------
*    NAME                 DATE                ODR              DESCRIPTION
* JEEVA T              31-10-2011         B.9-DIRECT DEBIT
* 04-APR-2023     Conversion tool   R22 Auto conversion      VM to @VM, ++ to +=
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.DATES
    $INSERT I_F.REDO.W.DIRECT.DEBIT

    FN.REDO.W.DIRECT.DEBIT = 'F.REDO.W.DIRECT.DEBIT'
    F.REDO.W.DIRECT.DEBIT = ''
    CALL OPF(FN.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT)

    FN.FUNDS.TRANSFER.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER.NAU = ''

    CALL OPF(FN.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU)
*CALL F.READ(FN.REDO.W.DIRECT.DEBIT,'FT',R.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT,Y.ERR)
    IDVAR.1 = 'FT' ;* R22 AUTO CONVERSION
*CALL F.READ(FN.REDO.W.DIRECT.DEBIT,IDVAR.1,R.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT,Y.ERR);* R22 AUTO CONVERSION
    CALL F.READU(FN.REDO.W.DIRECT.DEBIT,IDVAR.1,R.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT,Y.ERR,'');* R22 AUTO CONVERSION;* R22 AUTO CONVERSION
 
    Y.ID.LIST = R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.FT.ID>

    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE DCOUNT(Y.ID.LIST,@VM)
        Y.ID = Y.ID.LIST<1,Y.CNT>
        CALL F.DELETE(FN.FUNDS.TRANSFER.NAU,Y.ID)
        Y.CNT += 1
    REPEAT
    CALL F.DELETE(FN.REDO.W.DIRECT.DEBIT,'FT')
    Y.DATE.ID = R.DATES(EB.DAT.LAST.WORKING.DAY)
    CALL F.DELETE(FN.REDO.W.DIRECT.DEBIT,Y.DATE.ID)

RETURN
END
