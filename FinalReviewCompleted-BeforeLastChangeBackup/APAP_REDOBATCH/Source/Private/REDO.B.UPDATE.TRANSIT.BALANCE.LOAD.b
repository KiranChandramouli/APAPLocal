* @ValidationCode : Mjo0NDc3MDUyNDQ6Q3AxMjUyOjE2ODQ4NTQ0MDE2NDI6SVRTUzotMTotMTozOTM6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 393
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPDATE.TRANSIT.BALANCE.LOAD
*--------------------------------------------------------------
*Description: This is the batch routine to update the transit balance
*             based on the release of ALE.
*Modification
* Date                   who                   Reference              
* 17-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - NO CHANGES
* 17-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.UPDATE.TRANSIT.BALANCE.COMMON

    GOSUB PROCESS
RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------

    FN.REDO.TRANSIT.ALE = 'F.REDO.TRANSIT.ALE'
    F.REDO.TRANSIT.ALE  = ''
    CALL OPF(FN.REDO.TRANSIT.ALE,F.REDO.TRANSIT.ALE)

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS  = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.AC.LOCKED.EVENTS.HIS = 'F.AC.LOCKED.EVENTS$HIS'
    F.AC.LOCKED.EVENTS.HIS  = ''
    CALL OPF(FN.AC.LOCKED.EVENTS.HIS,F.AC.LOCKED.EVENTS.HIS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LOC.REF.APPLICATION   = "ACCOUNT"
    LOC.REF.FIELDS        = 'L.AC.TRAN.AVAIL'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AC.TRAN.AVAIL   = LOC.REF.POS<1,1>

RETURN
END
