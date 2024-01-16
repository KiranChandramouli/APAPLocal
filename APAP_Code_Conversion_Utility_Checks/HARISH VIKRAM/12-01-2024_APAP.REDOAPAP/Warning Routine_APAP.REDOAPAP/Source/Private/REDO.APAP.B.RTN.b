* @ValidationCode : Mjo5MTAwNjQwNzg6Q3AxMjUyOjE3MDMyMzI2MjQ3NjI6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Dec 2023 13:40:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.B.RTN(Y.ARRAY)
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This routine is used to retrieve the description for DISBURSEMENT or REPAYMENT from MULTI.TRANSACTION.PARAMETER table
*based upon the user selection
* IN PARAMETER :NA
* OUT PARAMETER:NA
* LINKED WITH  :
* LINKED FILE  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                 REFERENCE           DESCRIPTION
* 28.09.2010   Jeyachandran S                           INITIAL CREATION
* Date                   who                   Reference
* 04-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND FM TO @FM AND SM TO @SM
* 04-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*22-12-2023      HARISHVIKRAM                 R22 Manual conversion        F.READ to CACHE.READ
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.MULTI.TRANSACTION.SERVICE
    $INSERT I_F.MULTI.TRANSACTION.PARAMETER
    $INSERT I_F.ACCT.ACTIVITY

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB GOEND
RETURN
*--------------
OPENFILES:

    FN.MULTI.TRANSACTION.SERVICE = 'F.MULTI.TRANSACTION.SERVICE'
    F.MULTI.TRANSACTION.SERVICE = ''
    CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)

    FN.MULTI.TRANSACTION.PARAMETER = 'F.MULTI.TRANSACTION.PARAMETER'
    F.MULTI.TRANSACTION.PARAMETER = ''
    CALL OPF(FN.MULTI.TRANSACTION.PARAMETER,F.MULTI.TRANSACTION.PARAMETER)

    FN.ACCT.ACTIVITY = 'F.ACCT.ACTIVITY'
    F.ACCT.ACTIVITY = ''
    CALL OPF(FN.ACCT.ACTIVITY,F.ACCT.ACTIVITY)
RETURN
*-------------
PROCESS:

    Y.OPERATION = R.NEW(REDO.MTS.OPERATION)
    Y.ID = R.NEW(REDO.MTS.PAYMENT.MODE)<1,AV>
    Y.ID1 = CHANGE(Y.ID,@VM,@FM)
    Y.CNT6 = DCOUNT(Y.ID1,@FM)
    Y.ID3 = Y.ID1<Y.CNT6>

    SEL.CMD = "SELECT ": FN.MULTI.TRANSACTION.PARAMETER:" WITH @ID EQ ":Y.ID3: " AND  SETTLEMENT.TYPE EQ ":Y.OPERATION
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,F.ERR)

    SEL.LIST = CHANGE(SEL.LIST,@VM,@FM)
    Y.ID2 = DCOUNT(SEL.LIST,@FM)
    Y.INIT = 1
    LOOP
    WHILE Y.INIT LE Y.ID2
        Y.PAR.ID = SEL.LIST<Y.INIT>
*        CALL F.READ(FN.MULTI.TRANSACTION.PARAMETER,Y.PAR.ID,R.MULTI.TRANSACTION.PARAMETER,F.MULTI.TRANSACTION.PARAMETER,ERR)
        CALL CACHE.READ(FN.MULTI.TRANSACTION.PARAMETER,Y.PAR.ID,R.MULTI.TRANSACTION.PARAMETER,ERR)      ;*R22 Manual Conversion
        Y.SET.TYPE1 = R.MULTI.TRANSACTION.PARAMETER<REDO.TXN.PARAM.SETTLEMENT.TYPE>
        Y.SET.TYPE = CHANGE(Y.SET.TYPE1,@VM,@FM)
        Y.CNT3 = DCOUNT(Y.SET.TYPE,@FM)
        Y.START = 1
        LOOP
        WHILE Y.START LE Y.CNT3
            Y.VALUE = Y.SET.TYPE<Y.START>
            IF Y.VALUE EQ Y.OPERATION THEN
                LOCATE Y.OPERATION IN Y.SET.TYPE SETTING Y.POS1 THEN
                    Y.DESC<-1> = R.MULTI.TRANSACTION.PARAMETER<REDO.TXN.PARAM.SHORT.DESC,Y.POS1>
                    Y.DESC = CHANGE(Y.DESC,@FM,@SM)
                    R.NEW(REDO.MTS.PAYMENT.TYPE) = Y.DESC
                    Y.SET.TYPE<Y.POS1> = ''
                END
            END
            Y.START + =1
        REPEAT
        Y.INIT + = 1
    REPEAT
    Y.ARRAY<-1> = Y.DESC
RETURN
*--------------
GOEND:
END
