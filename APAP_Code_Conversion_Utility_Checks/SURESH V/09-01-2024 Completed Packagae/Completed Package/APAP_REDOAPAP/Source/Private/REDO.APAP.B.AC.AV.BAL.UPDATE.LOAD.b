* @ValidationCode : MjotMjA3Mjk0OTEyMDpDcDEyNTI6MTY4NDgzNjAzMzUxNDpJVFNTOi0xOi0xOjY1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 65
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.B.AC.AV.BAL.UPDATE.LOAD
*********************************************************************************************************
*Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By : Temenos Application Management
*Program Name : REDO.APAP.B.AC.AV.BAL.UPDATE.LOAD
*--------------------------------------------------------------------------------------------------------
*Description : REDO.APAP.B.AC.AV.BAL.UPDATE.LOAD is the load routine, this routine is used to
* update the local reference field L.AC.AV.BAL which will be difference between the
* amount of WORKING.BALANCE and LOCKED.AMOUNT
*Linked With : Batch BNK/REDO.B.AC.AV.BAL.UPDATE
*In Parameter : NA
*Out Parameter : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
* Date Who Reference Description
* ------ ----- ------------- -------------
* 24 Nov 2010 Shiva Prasad Y ODR-2010-11-0196 CR012 Initial Creation
* 27-Jan-2012 Gangadhar.S.V. Performance Tuning Changed MULTI.GET.LOC.REF to GET.LOC.REF
* Date                  who                   Reference              
* 04-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 04-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_REDO.APAP.B.AC.AV.BAL.UPDATE.COMMON
*--------------------------------------------------------------------------------------------------------
**********
*MAIN.PARA: ;* 27-Jan-2012 - S/E
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA
* GOSUB PROCESS.PARA ;* 27-Jan-2012 - S/E

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
    LOC.L.AC.AV.BAL.POS = '' ;* 27-Jan-2012 - S
    CALL GET.LOC.REF('ACCOUNT','L.AC.AV.BAL',LOC.L.AC.AV.BAL.POS) ;* 27-Jan-2012 - E

*
RETURN
*--------------------------------------------------------------------------------------------------------
*************
*PROCESS.PARA: ;* 27-Jan-2012 - S
*************
* GOSUB FIND.MULTI.LOCAL.REF

* RETURN
*--------------------------------------------------------------------------------------------------------
*********************
*FIND.MULTI.LOCAL.REF:
*********************
* APPL.ARRAY = 'ACCOUNT'
* FLD.ARRAY = 'L.AC.AV.BAL'
* FLD.POS = ''

* CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

* LOC.L.AC.AV.BAL.POS = FLD.POS<1,1>

* RETURN ;* 27-Jan-2012 - E
*--------------------------------------------------------------------------------------------------------
END ;* ENd of Program
