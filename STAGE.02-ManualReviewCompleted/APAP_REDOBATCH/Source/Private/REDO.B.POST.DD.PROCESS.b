* @ValidationCode : MjoxNDgzODAzMjQ6Q3AxMjUyOjE2ODA3OTAxMDk2NDc6SVRTUzotMTotMTo0MDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 400
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.POST.DD.PROCESS
*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.POST.DD.PROCESS
* Primary Purpose : Clearing all record from the template 'REDO.W.DIRECT.DEBIT'
* MODIFICATION HISTORY
*-------------------------------
*-----------------------------------------------------------------------------------
*    NAME                 DATE                ODR              DESCRIPTION
* JEEVA T              31-10-2011         B.9-DIRECT DEBIT
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.W.DIRECT.DEBIT


    FN.REDO.W.DIRECT.DEBIT = 'F.REDO.W.DIRECT.DEBIT'
    F.REDO.W.DIRECT.DEBIT = ''
    CALL OPF(FN.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT)

    CALL F.DELETE(FN.REDO.W.DIRECT.DEBIT,'TODAY')

    CALL CACHE.READ(FN.REDO.W.DIRECT.DEBIT,'SYSTEM',R.REDO.W.DIRECT.DEBIT,Y.ERR)
    SEL.CMD = ' SELECT ':FN.REDO.W.DIRECT.DEBIT:' WITH @ID LIKE UPDATE-...'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOF,Y.ERR)
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POD
    WHILE Y.ID:POD
        Y.ACCOUNT = FIELD(Y.ID,'-',2)
        LOCATE Y.ACCOUNT IN R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.ARR.ID,1> SETTING POS ELSE
            R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.ARR.ID,-1> = Y.ACCOUNT
            CALL F.WRITE(FN.REDO.W.DIRECT.DEBIT,'SYSTEM',R.REDO.W.DIRECT.DEBIT)
        END
        CALL F.DELETE(FN.REDO.W.DIRECT.DEBIT,Y.ID)
    REPEAT
RETURN
END
