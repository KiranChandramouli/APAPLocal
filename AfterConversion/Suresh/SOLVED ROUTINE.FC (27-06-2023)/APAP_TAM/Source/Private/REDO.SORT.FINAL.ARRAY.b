* @ValidationCode : MjotMTExODMyNjI3MDpDcDEyNTI6MTY4Nzg0MTE1ODYxMjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Jun 2023 10:15:58
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
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.SORT.FINAL.ARRAY(Y.FIN.ARR,Y.OUT.ARRAY)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.NOF.GEN.CHQ.AGENCY
* ODR NUMBER    : ODR-2010-03-0131
*-----------------------------------------------------------------------------
* Description   : This is nofile routine, will fetch the values to pass to enquiry
* In parameter  : none
* out parameter : Y.FIN.ARR
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 10-01-2011      JEEVA T        ODR-2010-03-0131   Initial Creation
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*26/06/2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION             NOCHANGE
*26/06/2023      SURESH                     MANUAL R22 CODE CONVERSION       INSERT FILE MODIFIED
*----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.MULTI.TRANSACTION.SERVICE
*   $INSERT I_F.T24.FUND.SERVICES         ;*R22 MANUAL CODE CONVERSION
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.RELATION
    $INSERT I_F.REDO.TRANS.TYPES.FT.PARAM
    $INSERT I_F.REDO.TRANS.TYPES.TT.PARAM
    $INSERT I_F.COMPANY
    $INSERT I_REDO.OPEN.FILES.R33.COMMON


    Y.FINAL.ARRAY = Y.FIN.ARR
    Y.REC.COUNT = DCOUNT(Y.FINAL.ARRAY,@FM)
    Y.REC.START = 1
    LOOP
    WHILE Y.REC.START LE Y.REC.COUNT
        Y.REC = Y.FINAL.ARRAY<Y.REC.START>
        Y.ACOF = FIELD(Y.REC,'*',4)
        Y.CCY  = FIELD(Y.REC,'*',9)

        Y.SORT.VAL = FMT(Y.ACOF,'R%12'):Y.CCY
        Y.AZ.SORT.VAL<-1> = Y.REC:@FM:Y.SORT.VAL
        Y.SORT.ARR<-1>= Y.SORT.VAL
        Y.REC.START += 1
    REPEAT

    Y.SORT.ARR = SORT(Y.SORT.ARR)
    LOOP
        REMOVE Y.ARR.ID FROM Y.SORT.ARR SETTING Y.ARR.POS
    WHILE Y.ARR.ID : Y.ARR.POS
        LOCATE Y.ARR.ID IN Y.AZ.SORT.VAL SETTING Y.FM.POS THEN
            Y.OUT.ARRAY<-1> = Y.AZ.SORT.VAL<Y.FM.POS-1>
            DEL Y.AZ.SORT.VAL<Y.FM.POS>
            DEL Y.AZ.SORT.VAL<Y.FM.POS-1>
        END
    REPEAT
RETURN
END
