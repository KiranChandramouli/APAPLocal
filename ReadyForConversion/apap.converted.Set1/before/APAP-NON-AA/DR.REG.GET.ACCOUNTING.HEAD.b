*
    *-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REG.GET.ACCOUNTING.HEAD(ACCOUNTING.HEAD,L.ASSET.TYPE)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE TAM.BP I_F.REDO.AZACC.DESC
    ACCOUNT.HEAD = ACCOUNTING.HEAD
    ACCOUNTING.HEAD = ''
    NO.OF.AT =  DCOUNT(L.ASSET.TYPE,FM)
    FOR IAT = 1 TO NO.OF.AT
        CHK.ASSET =  L.ASSET.TYPE<IAT>
        FMPOS =  '' ; VMPOS = '' ; SMPOS  = ''
        FIND CHK.ASSET IN ACCOUNT.HEAD SETTING FMPOS,VMPOS,SMPOS THEN
            ACCOUNTING.HEAD = ACCOUNT.HEAD<AZACC.DESC,VMPOS>
            EXIT
        END
    NEXT IAT
    RETURN
