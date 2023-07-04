* @ValidationCode : MjoxMDQxNzc3NTQyOkNwMTI1MjoxNjg0ODU0Mzk0NDkwOklUU1M6LTE6LTE6MzAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 300
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.PRE.DEL.PROCESS
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
* Date                  who                   Reference              
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.W.DIRECT.DEBIT


    FN.REDO.W.DIRECT.DEBIT = 'F.REDO.W.DIRECT.DEBIT'
    F.REDO.W.DIRECT.DEBIT = ''
    CALL OPF(FN.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT)

    CALL CACHE.READ(FN.REDO.W.DIRECT.DEBIT,'SYSTEM',R.REDO.W.DIRECT.DEBIT,Y.ERR)
    SEL.CMD = ' SELECT ':FN.REDO.W.DIRECT.DEBIT:' WITH @ID LIKE DEL-...'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOF,Y.ERR)

    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POD
    WHILE Y.ID:POD
        Y.ACCOUNT = FIELD(Y.ID,'-',2)
        LOCATE Y.ACCOUNT IN R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.ARR.ID,1> SETTING POS THEN
            DEL R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.ARR.ID,POS>
            CALL F.WRITE(FN.REDO.W.DIRECT.DEBIT,'SYSTEM',R.REDO.W.DIRECT.DEBIT)
        END
        CALL F.DELETE(FN.REDO.W.DIRECT.DEBIT,Y.ID)

    REPEAT
RETURN
END
