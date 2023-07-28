* @ValidationCode : MjoxMDgzNDM4MTE4OkNwMTI1MjoxNjg0ODU0NDAwNjMxOklUU1M6LTE6LTE6MjAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPD.USER.LOG.LOAD
*-------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.UPD.USER.LOG.LOAD
*-------------------------------------------------------------------------
*Description  : This is a validation routine to check the card is valid or
*               This routine has to be attached to versions used in ATM tr
*               to find out whether the status entered is valid or not
*In Parameter : N/A
*Out Parameter: N/A
*-------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who              Description
*   ------         ------             -------------
* 01 NOV  2010     SRIRAMAN.C         Initial
* 12-05-2015      Ashokkumar          Changed the file from PROTOCOL to PROTOCOL.TEMP
* Date                  who                   Reference              
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.UPD.USER.LOG.COMMON


    FN.LOGG = 'F.REDO.L.USER.LOG'
    F.LOGG =''
    CALL OPF(FN.LOGG,F.LOGG)

    FN.PROTO='F.PROTOCOL.TEMP'
    F.PROTO=''
    CALL OPF( FN.PROTO,F.PROTO)
RETURN
END
